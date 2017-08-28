require "aws-sdk"

module Lono::Template::AwsServices
  def s3
    @s3 ||= Aws::S3::Client.new
  end
end
