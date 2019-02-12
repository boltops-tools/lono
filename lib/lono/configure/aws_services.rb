require "aws-sdk-ec2"
require "aws-sdk-iam"

class Lono::Configure
  module AwsServices
    def ec2
      @ec2 ||= Aws::EC2::Client.new
    end

    def iam
      @iam ||= Aws::IAM::Client.new
    end

    def sts
      @sts ||= Aws::STS::Client.new # part of aws-sdk-core
    end
  end
end
