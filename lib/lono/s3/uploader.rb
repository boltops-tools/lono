module Lono::S3
  class Uploader
    extend Memoist
    include Lono::AwsServices
    include Lono::Utils::Logging
    include Lono::Utils::Pretty

    attr_reader :local_path
    def initialize(local_path, options={})
      @local_path, @options = local_path, options
      @checksums = {}
    end

    # Inputs:
    #
    #   local_path: can be full path or relative path
    #
    def upload
      logger.debug "May upload   #{local_path}"
      logger.debug "To           #{s3_path}"

      local_checksum = Digest::MD5.hexdigest(IO.read(local_path))
      if local_checksum == remote_checksum
        logger.debug "Not modified #{s3_path}"
        return # do not upload unless the checksum has changed
      else
        # Example output:
        # Uploaded: files/ecs/private.yml to s3://bucket/output/demo/files/ecs/private.yml
        logger.debug "Uploading #{pretty_path(local_path)} to #{s3_path}"
      end

      s3.put_object(
        body: IO.read(local_path),
        bucket: s3_bucket,
        key: s3_key,
      )
    end

    # https://s3.amazonaws.com/mybucket/development/output/blueprint/templates/blueprint.yml
    def https_url
      "https://s3.amazonaws.com/#{s3_bucket}/#{s3_key}"
    end

    def presigned_url
      s3_presigner.presigned_url(:get_object, bucket: s3_bucket, key: s3_key)
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
        #    full path = s3://my-bucket/files/production/my-template.yml
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
    # s3 path: s3://bucket/cloudformation/production/files/lifecycle-0719ab81.zip
    # s3_folder: s3://bucket/cloudformation
    def remote_checksum
      load_checksums!(s3_key)
      @checksums[s3_key]
    end

    def strip_surrounding_quotes(string)
      string.sub(/^"/,'').sub(/"$/,'')
    end

    def s3_path
      "s3://#{s3_bucket}/#{s3_key}"
    end

    def s3_key
      "#{Lono.env}/#{pretty_path(local_path)}"
    end

    def s3_bucket
      Lono::S3::Bucket.name
    end
  end
end
