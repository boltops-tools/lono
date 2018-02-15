require "aws-sdk-s3"

module Lono::Template::AwsService
  def s3
    return @s3 if @s3

    options = {}
    # example: endpoint: 'https://s3.us-west-2.amazonaws.com'
    options[:endpoint] = ENV['S3_ENDPOINT'] if ENV['S3_ENDPOINT']
    @s3 = Aws::S3::Client.new(options)
  end
end
