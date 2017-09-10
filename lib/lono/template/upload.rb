require 'erb'
require 'json'
require 'base64'
require 'digest'

class Lono::Template::Upload
  include Lono::Template::AwsServices

  def initialize(options={})
    @options = options
    @project_root = options[:project_root] || '.'
    @checksums = {}
  end

  def run
    ensure_s3_setup!
    load_checksums!

    paths = Dir.glob("#{@project_root}/output/**/*")
    paths.reject { |p| p =~ %r{output/params} }.
          select { |p| File.file?(p) }.each do |path|
      upload(path)
    end
    say "Templates uploaded to s3."
  end

  # Read existing files on s3 to grab their md5 checksum.
  # We do this so we can see if we should avoid re-uploading the s3 child template
  # entirely. If we upload a new child template that does not change AWS CloudFormation
  # is not smart enough to know that it not has changed. I think all AWS CloudFormation
  # does is check if the file's timestamp.
  #
  # Thought this would result in better AWS Change Set info but AWS still reports child
  # stacks being changed even though they should not be reported.  Leaving this s3 checksum
  # in for now.
  def load_checksums!
    prefix = "#{s3_path}/#{LONO_ENV}" # s3://s3-bucket-and-path-from-settings/prod
    resp = s3.list_objects(bucket: s3_bucket, prefix: prefix)
    resp.contents.each do |object|
      # key does not include the bucket name
      #    full path = s3://my-bucket/cloudformation-templates/prod/my-template.yml
      #    key = cloudformation-templates/prod/my-template.yml
      # etag is the checksum as long as the file is not a multi-part file upload
      # it has extra double quotes wrapped around it.
      #    etag = "\"9cb437490cee2cc96101baf326e5ca81\""
      @checksums[object.key] = strip_surrounding_quotes(object.etag)
    end
    @checksums
  end

  def strip_surrounding_quotes(string)
    string.sub(/^"/,'').sub(/"$/,'')
  end

  def upload(path)
    pretty_path = path.sub(/^\.\//, '')
    key = "#{s3_path}/#{LONO_ENV}/#{pretty_path.sub(/^output\//,'')}"
    s3_full_path = "s3://#{s3_bucket}/#{key}"

    local_checksum = Digest::MD5.hexdigest(IO.read(path))
    remote_checksum = remote_checksum(path)
    puts "path: #{path}"
    puts "local_checksum #{local_checksum.inspect}"
    puts "remote_checksum #{remote_checksum.inspect}"
    if local_checksum == remote_checksum
      say("Not modified: #{pretty_path} to #{s3_full_path}".colorize(:yellow)) unless @options[:noop]
      return # do not upload unless the checksum has changed
    end

    resp = s3.put_object(
      body: IO.read(path),
      bucket: s3_bucket,
      key: key,
      storage_class: "REDUCED_REDUNDANCY"
    ) unless @options[:noop]

    # Example output:
    # Uploaded: output/docker.yml to s3://boltops-stag/cloudformation-templates/stag/docker.yml
    # Uploaded: output/ecs/private.yml to s3://boltops-stag/cloudformation-templates/stag/ecs/private.yml
    message = "Uploaded: #{pretty_path} to #{s3_full_path}".colorize(:green)
    message = "NOOP: #{message}" if @options[:noop]
    say message
  end

  # @checksums map has a key format: cloudformation-templates/stag/docker.yml
  #
  # path = ./output/docker.yml
  # s3_path = s3://boltops-stag/cloudformation-templates/stag/docker.yml
  def remote_checksum(path)
    # first convert the local path to the path format that is stored in @checksums keys
    # ./output/docker.yml => cloudformation-templates/stag/docker.yml
    pretty_path = path.sub(/^\.\//, '')
    key = "#{s3_path}/#{LONO_ENV}/#{pretty_path.sub(/^output\//,'')}"
    @checksums[key]
  end

  # https://s3.amazonaws.com/mybucket/cloudformation-templates/prod/parent.yml
  def s3_https_url(template_path)
    ensure_s3_setup!
    "https://s3.amazonaws.com/#{s3_bucket}/#{s3_path}/#{LONO_ENV}/#{template_path}"
  end

  # Example:
  #    s3_bucket('s3://mybucket/templates/storage/path') => mybucket
  def s3_bucket
    @s3_full_path.sub('s3://','').split('/').first
  end

  # Example:
  #    s3_bucket('s3://mybucket/templates/storage/path') => templates/storage/path
  def s3_path
    @s3_full_path.sub('s3://','').split('/')[1..-1].join('/')
  end

  # nice warning if the s3 path not found
  def ensure_s3_setup!
    return if @options[:noop]

    settings = Lono::Settings.new(@project_root)
    if settings.s3_path
      @s3_full_path = settings.s3_path
    else
      say "Unable to upload templates to s3 because you have not configured the s3.path option in .lono/settings.yml.".colorize(:red)
      say "Please configure .lono/settings.yml with s3.path.  Refer to http://lono.cloud/docs/settings/ for more help.".colorize(:red)
      exit 1
    end
  end

  def say(message)
    puts message unless @options[:quiet]
  end
end
