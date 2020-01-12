#!/usr/bin/env ruby

require "aws-sdk-ec2"
require "fileutils"

# Usage:
#
#   blueprints/ec2/bin/configure
#
# This configures the ec2 blueprint parameters and variables with some default
# settings specific to your AWS account and meant to help you get started quickly.
# After it runs inspect the configs/ec2/params and configs/ec2/variables folder
# and adjust according.
#
class Configure
  def run
    puts "Setting up starter values for blueprint/ec2"
    resp = ec2.describe_vpcs
    vpcs = resp.vpcs

    # TODO: Prompt user for vpc or subnet they might want to use.
    vpc = vpcs.first

    return unless vpc # sometimes even default VPC has been deleted

    resp = ec2.describe_subnets(filters: [{name: 'vpc-id', values: [vpc.vpc_id]}])
    subnet = resp.subnets.first # first subnet
    subnet_id = if subnet
      subnet.subnet_id
    else
      "Please provide a subnet id"
    end

    resp = ec2.describe_key_pairs
    key = resp.key_pairs.first

    key_name = if key
      key.key_name
    else
      "Please create a keypair and configure it here"
    end


    param_content =<<~EOL
      InstanceType=<%= @instance_type %>
      KeyName=#{key_name}
      SubnetId=#{subnet_id}
    EOL
    variable_content =<<~EOL
      @instance_type = "t2.micro"
    EOL

    write_file("configs/ec2/params/development/ec2.txt", param_content)
    write_file("configs/ec2/variables/development.rb", variable_content)

    puts message
  end

  def write_file(path, content)
    FileUtils.mkdir_p(File.dirname(path))
    IO.write(path, content)
  end

  def message
    <<~EOL
      The ec2 blueprint configs are in:

        * configs/ec2/params
        * configs/ec2/variables

      The starter values are specific to your AWS account. They meant to
      be starter values. Please inspect the values and adjust to your needs.
    EOL
  end

  def ec2
    @ec2 ||= Aws::EC2::Client.new
  end
end

if __FILE__ == $0
  Configure.new.run
end