module Lono::Builder::Dsl::Helpers
  module S3
    def s3_bucket
      Lono::S3::Bucket.name
    end
    alias_method :lono_bucket_name, :s3_bucket
    alias_method :files_bucket, :s3_bucket

    def s3_key(name, options={})
      default = {type: "file"}
      options.reverse_merge!(default)
      "file://app/files/#{options[:type]}/#{name}" # placeholder for post processing
    end
    alias_method :file_s3_key, :s3_key
  end
end
