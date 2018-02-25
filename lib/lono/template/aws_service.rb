require "aws-sdk-s3"

module Lono::Template::AwsService
  def s3
    return @s3 if @s3

    options = {}
    # example: endpoint: 'https://s3.us-west-2.amazonaws.com'
    options[:endpoint] = ENV['S3_ENDPOINT'] if ENV['S3_ENDPOINT']
    # allow override of region for s3 client to avoid warning:
    # S3 client configured for "us-east-1" but the bucket "xxx" is in "us-west-2"; Please configure the proper region to avoid multiple unnecessary redirects and signing attempts
    options[:region] = ENV['S3_REGION'] if ENV['S3_REGION']
    @s3 = Aws::S3::Client.new(options)
  end
end
