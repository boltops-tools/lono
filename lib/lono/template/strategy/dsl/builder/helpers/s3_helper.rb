module Lono::Template::Strategy::Dsl::Builder::Helpers
  module S3Helper
    def s3_bucket
      Lono::S3::Bucket.name
    end
    alias_method :lono_bucket_name, :s3_bucket

    def s3_key(name, options={})
      default = {type: "file"}
      options.reverse_merge!(default)
      Lono::AppFile::Registry.register(name, @blueprint, options)
      "file://app/files/#{options[:type]}/#{name}" # placeholder for post processing
    end
    alias_method :file_s3_key, :s3_key
  end
end
