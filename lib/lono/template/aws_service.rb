require "aws-sdk-s3"

module Lono::Template::AwsService
  def s3
    return @s3 if @s3

    options = {}
    # allow override of region for s3 client to avoid warning:
    # S3 client configured for "us-east-1" but the bucket "xxx" is in "us-west-2"; Please configure the proper region to avoid multiple unnecessary redirects and signing attempts
    # Example: endpoint: 'https://s3.us-west-2.amazonaws.com'
    settings = Lono::Setting.new.data
    endpoint = settings["s3_endpoint"]
    endpoint = ENV['S3_ENDPOINT'] if ENV['S3_ENDPOINT']
    options[:endpoint] = endpoint if endpoint
    if options[:endpoint]
      options[:region] = options[:endpoint].split('.')[1]
    end
    @s3 = Aws::S3::Client.new(options)
  end
end
