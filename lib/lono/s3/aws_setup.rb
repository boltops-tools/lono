class Lono::S3
  class AwsSetup
    include Lono::AwsServices

    def check!
      s3.config.region
    rescue Aws::Errors::MissingRegionError => e
      puts "ERROR: #{e.class}: #{e.message}".color(:red)
      puts <<~EOL
        Unable to detect the AWS_REGION to make AWS API calls. This is might be because the AWS access
        has not been set up yet. Please either your ~/.aws files.
      EOL
      exit 1
    end
  end
end
