module Lono::Builder::Dsl::Helpers
  module S3
    def s3_bucket
      Lono::S3::Bucket.name
    end
    alias_method :lono_bucket, :s3_bucket

    # Edge case when bucket is created for the first time and files_bucket is
    # not available yet to be use by Finalizer::Files::Replace#replacements
    def files_bucket
      "LONO://S3_BUCKET"
    end
  end
end
