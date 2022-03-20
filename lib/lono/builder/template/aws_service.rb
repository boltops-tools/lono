require "aws-sdk-s3"

class Lono::Builder::Template::AwsService
  def s3
    return @s3 if @s3

    options = {}
    endpoint = ENV['S3_ENDPOINT'] if ENV['S3_ENDPOINT']
    options[:endpoint] = endpoint if endpoint
    if options[:endpoint]
      options[:region] = options[:endpoint].split('.')[1]
    end
    @s3 = Aws::S3::Client.new(options)
  end
end
