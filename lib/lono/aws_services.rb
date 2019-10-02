require "aws-sdk-cloudformation"
require "aws-sdk-ec2"
require "aws-sdk-iam"
require "aws-sdk-s3"

module Lono
  module AwsServices
    extend Memoist
    include Util

    def ec2
      Aws::EC2::Client.new
    end
    memoize :ec2

    def iam
      Aws::IAM::Client.new
    end
    memoize :iam

    def sts
      Aws::STS::Client.new # part of aws-sdk-core
    end
    memoize :sts

    def s3
      Aws::S3::Client.new
    end
    memoize :s3

    def s3_resource
      Aws::S3::Resource.new
    end
    memoize :s3_resource

    def s3_presigner
      Aws::S3::Presigner.new(client: s3)
    end
    memoize :s3_presigner

    def cfn
      Aws::CloudFormation::Client.new
    end
    memoize :cfn
  end
end
