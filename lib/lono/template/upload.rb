require 'erb'
require 'json'
require 'base64'
require 'digest'

class Lono::Template::Upload
  include Lono::Template::AwsService

  def initialize(options={})
    @options = options
    @checksums = {}
    @prefix = "#{folder_key}/#{Lono.env}/templates" # s3://s3-bucket/folder/development/templates
  end

  def run
    ensure_s3_setup!
    load_checksums!

    paths = Dir.glob("#{Lono.config.output_path}/templates/**/*")
    paths.select { |p| File.file?(p) }.each do |path|
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
    return if @options[:noop]

    resp = s3.list_objects(bucket: s3_bucket, prefix: @prefix)
    resp.contents.each do |object|
      # key does not include the bucket name
      #    full path = s3://my-bucket/s3_folder/templates/production/my-template.yml
      #    key = s3_folder/templates/production/my-template.yml
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
    key = "#{@prefix}/#{pretty_path.sub(%r{output/templates/},'')}"
    s3_full_path = "s3://#{s3_bucket}/#{key}"

    local_checksum = Digest::MD5.hexdigest(IO.read(path))
    remote_checksum = remote_checksum(path)
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
    # Uploaded: output/templates/docker.yml to s3://boltops-dev/s3_folder/templates/development/docker.yml
    # Uploaded: output/templates/ecs/private.yml to s3://boltops-dev/s3_folder/templates/development/ecs/private.yml
    message = "Uploaded: #{pretty_path} to #{s3_full_path}".colorize(:green)
    message = "NOOP: #{message}" if @options[:noop]
    say message
  end

  # @checksums map has a key format: s3_folder/templates/development/docker.yml
  #
  # path = ./output/templates/docker.yml
  # s3_folder = s3://boltops-dev/s3_folder/templates/development/docker.yml
  def remote_checksum(path)
    # first convert the local path to the path format that is stored in @checksums keys
    # ./output/templates/docker.yml => s3_folder/templates/development/docker.yml
    pretty_path = path.sub(/^\.\//, '')
    key = "#{@prefix}/#{pretty_path.sub(%r{output/templates/},'')}"
    @checksums[key]
  end

  # https://s3.amazonaws.com/mybucket/s3_folder/templates/production/parent.yml
  def s3_https_url(template_path)
    ensure_s3_setup!
    "https://s3.amazonaws.com/#{s3_bucket}/#{@prefix}/#{template_path}"
  end

  # Parse the s3_folder setting and remove the folder portion to leave the
  # "s3_bucket" portion
  # Example:
  #    s3_bucket('s3://mybucket/templates/storage/path')
  #    => mybucket
  def s3_bucket
    return nil if @options[:noop] # to get spec passing
    return nil unless s3_folder
    s3_folder.sub('s3://','').split('/').first
  end

  # The folder_key is the s3_folder setting with the s3 bucket.
  #
  # Example:
  #    s3_bucket('s3://mybucket/templates/storage/path')
  #    => templates/storage/path
  def folder_key
    return nil if @options[:noop] # to get spec passing
    return nil unless s3_folder
    s3_folder.sub('s3://','').split('/')[1..-1].join('/')
  end

  def s3_folder
    settings = Lono::Setting.new
    settings.s3_folder
  end

  # nice warning if the s3 path not found
  def ensure_s3_setup!
    return if @options[:noop]
    return if s3_folder

    say "Unable to upload templates to s3 because you have not configured the s3_folder option in lono settings.yml.".colorize(:red)
    say "Please configure settings.yml with s3_folder.  For more help: http://lono.cloud/docs/settings/".colorize(:red)
    exit 1
  end

  def say(message)
    puts message unless @options[:quiet]
  end
end
