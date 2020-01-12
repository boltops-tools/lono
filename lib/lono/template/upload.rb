require 'erb'
require 'json'
require 'base64'
require 'digest'

class Lono::Template
  class Upload < Lono::AbstractBase
    include Lono::AwsServices

    def initialize(options={})
      super
      @checksums = {}
      @prefix = Lono.env # s3://s3-bucket/development
    end

    def run
      load_checksums!

      say "Uploading CloudFormation templates..."
      paths = Dir.glob("#{Lono.config.output_path}/#{@blueprint}/templates/**/*")
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
        @checksums[object.key] = strip_surrounding_quotes(object.etag)
      end
      @checksums
    end

    def strip_surrounding_quotes(string)
      string.sub(/^"/,'').sub(/"$/,'')
    end

    def upload(path)
      return if @options[:noop]

      path = path.sub("#{Lono.root}/",'')
      pretty_path = path.sub(/^\.\//, '')
      key = "#{@prefix}/#{pretty_path.sub(%r{output/templates/},'')}"
      s3_full_path = "s3://#{s3_bucket}/#{key}"

      local_checksum = Digest::MD5.hexdigest(IO.read(path))
      remote_checksum = remote_checksum(path)
      if local_checksum == remote_checksum
        say("Not modified: #{pretty_path} to #{s3_full_path}".color(:yellow)) unless @options[:noop]
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
      message = "Uploaded: #{pretty_path} to #{s3_full_path}".color(:green)
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
      "https://s3.amazonaws.com/#{s3_bucket}/#{@prefix}/#{template_path}"
    end

    # used for cfn/base.rb def set_template_url!(options)
    def s3_presigned_url(template_output_path)
      template_path = template_output_path.sub('output/templates/','')
      key = "#{@prefix}/#{template_path}"
      s3_presigner.presigned_url(:get_object, bucket: s3_bucket, key: key)
    end

    # Parse the s3_folder setting and remove the folder portion to leave the
    # "s3_bucket" portion
    # Example:
    #    s3_bucket('s3://mybucket/templates/storage/path')
    #    => mybucket
    def s3_bucket
      Lono::S3::Bucket.name
    end

    def say(message)
      puts message unless @options[:quiet]
    end
  end
end