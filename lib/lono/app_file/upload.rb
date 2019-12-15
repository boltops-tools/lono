module Lono::AppFile
  class Upload < Base
    include Lono::AwsServices
    extend Memoist

    def upload
      return unless Registry.items.size > 0
      puts "Uploading app/files..."

      Registry.items.each do |item|
        s3_upload(item)
      end
    end

    # TODO: check md5sum and only upload if it changes
    def s3_upload(item)
      filepath = item.zip_file_path
      s3_key = item.s3_path
      s3_path = "s3://#{s3_bucket}/#{s3_key}"
      message = "Uploading: #{filepath} to #{s3_path}".color(:green)
      message = "NOOP: #{message}" if @options[:noop]
      puts message
      return if @options[:noop]

      s3.put_object(
        body: IO.read(filepath),
        bucket: s3_bucket,
        key: s3_key,
      )
    end

    def s3_bucket
      Lono::S3::Bucket.name
    end
  end
end
