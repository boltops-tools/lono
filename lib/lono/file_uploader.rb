module Lono
  class FileUploader < AbstractBase
    include Lono::Template::AwsService
    extend Memoist

    def initialize(options={})
      super
      @checksums = {}
      @prefix = "#{folder_key}/#{Lono.env}/#{blueprint}/files" # s3://s3-bucket/folder/development/files
    end

    def upload_all
      # pattern = "#{Lono.blueprint_root}/app/files/**/*"
      # size = Dir.glob(pattern).size
      # puts "size #{size}"
      # return unless Dir.glob(pattern).size > 0
      # puts "Uploading app/files2..."
      load_checksums!

      Dir.glob(pattern).each do |path|
        next if ::File.directory?(path)
        s3_upload(path)
      end
    end

    def load_checksums!
      resp = s3.list_objects(bucket: s3_bucket, prefix: @prefix)
      resp.contents.each do |object|
        # key does not include the bucket name
        #    full path = s3://my-bucket/s3_folder/files/production/my-template.yml
        #    key = s3_folder/files/production/my-template.yml
        # etag is the checksum as long as the file is not a multi-part file upload
        # it has extra double quotes wrapped around it.
        #    etag = "\"9cb437490cee2cc96101baf326e5ca81\""
        @checksums[object.key] = strip_surrounding_quotes(object.etag)
      end
      @checksums
    end

    # used for file_s3_key helper
    def md5(path)
      Digest::MD5.file(path).to_s[0..7]
    end
    memoize :md5

    def md5_key(path)
      pretty_path = path.sub(/^\.\//, '')
      key = "#{@prefix}/#{pretty_path.sub(%r{app/files/},'')}"
      # add the short md5sum to the file
      key = key.sub(/\.(\w+)$/,'') # strip extension
      ext = $1
      md5 = md5(path)
      "#{key}-#{md5}.#{ext}"
    end

    # Inputs:
    #
    #   path: can be full path or relative path
    #
    def s3_upload(path)
      path = path.gsub("#{Lono.root}/",'') # remove Lono.root
      pretty_path = path.sub(/^\.\//, '')
      key = md5_key(path)
      s3_full_path = "s3://#{s3_bucket}/#{key}"

      local_checksum = Digest::MD5.hexdigest(IO.read(path))
      remote_checksum = remote_checksum(key)
      if local_checksum == remote_checksum
        puts("Not modified: #{pretty_path} to #{s3_full_path}".color(:yellow)) unless @options[:noop]
        return # do not upload unless the checksum has changed
      else
        # Example output:
        # Uploaded: app/files/docker.yml to s3://boltops-dev/s3_folder/templates/development/docker.yml
        # Uploaded: app/files/ecs/private.yml to s3://boltops-dev/s3_folder/templates/development/ecs/private.yml
        message = "Uploading: #{pretty_path} to #{s3_full_path}".color(:green)
        message = "NOOP: #{message}" if @options[:noop]
        puts message
      end

      resp = s3.put_object(
        body: IO.read(path),
        bucket: s3_bucket,
        key: key,
        storage_class: "REDUCED_REDUNDANCY"
      ) unless @options[:noop]
    end

    # key example: cloudformation/production/files/lifecycle-0719ab81.zip
    # s3 path: s3://boltops-dev/cloudformation/production/files/lifecycle-0719ab81.zip
    # s3_folder: s3://boltops-dev/cloudformation
    def remote_checksum(key)
      @checksums[key]
    end

    def s3_bucket
      s3_folder.sub('s3://','').split('/').first
    end

    def s3_folder
      setting = Lono::Setting.new
      setting.s3_folder
    end

    # The folder_key is the s3_folder setting with the s3 bucket.
    #
    # Example:
    #    s3_bucket('s3://mybucket/files/storage/path')
    #    => files/storage/path
    def folder_key
      return nil if @options[:noop] # to get spec passing
      return nil unless s3_folder
      s3_folder.sub('s3://','').split('/')[1..-1].join('/')
    end

    def strip_surrounding_quotes(string)
      string.sub(/^"/,'').sub(/"$/,'')
    end

    def s3_resource
      @s3_resource ||= Aws::S3::Resource.new
    end

    def s3
      @s3 ||= Aws::S3::Client.new
    end
  end
end
