class Lono::S3
  class Uploader
    include Lono::AwsServices
    extend Memoist

    attr_reader :path
    def initialize(path, options={})
      @path, @options = path, options
      @checksums = {}
    end

    # Inputs:
    #
    #   path: can be full path or relative path
    #
    def upload
      return if @options[:noop] || ENV['LONO_TEST'] == '1'

      path = @path.gsub("#{Lono.root}/",'') # remove Lono.root
      key = "#{Lono.env}/#{path}"

      pretty_path = path.sub(/^\.\//, '')
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

      s3.put_object(
        body: IO.read(path),
        bucket: s3_bucket,
        key: key,
      ) unless @options[:noop]
    end

    # https://s3.amazonaws.com/mybucket/development/output/blueprint/templates/blueprint.yml
    def https_url
      key = "#{Lono.env}/#{@path}"
      "https://s3.amazonaws.com/#{s3_bucket}/#{key}"
    end

    def presigned_url
      key = "#{Lono.env}/#{@path}"
      s3_presigner.presigned_url(:get_object, bucket: s3_bucket, key: key)
    end

    # used for file_s3_key helper
    def md5(path)
      Digest::MD5.file(path).to_s[0..7]
    end
    memoize :md5

    def load_checksums!(prefix)
      resp = s3.list_objects(bucket: s3_bucket, prefix: prefix)
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
    memoize :load_checksums!

    # key example: cloudformation/production/files/lifecycle-0719ab81.zip
    # s3 path: s3://boltops-dev/cloudformation/production/files/lifecycle-0719ab81.zip
    # s3_folder: s3://boltops-dev/cloudformation
    def remote_checksum(key)
      load_checksums!(key)
      @checksums[key]
    end

    def strip_surrounding_quotes(string)
      string.sub(/^"/,'').sub(/"$/,'')
    end

    def s3_bucket
      Lono::S3::Bucket.name
    end
  end
end
