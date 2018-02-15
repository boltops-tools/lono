# Autoscaling Lono Example

## Usage

```
lono cfn create autoscaling
```

## How This Example Was Built

First generate a skeleton starter lono project.

```sh
TEMPLATE=skeleton lono new autoscaling
```

Then import a normal CloudFormatoin template into lono. The `--name` option is used to rename the template `autoscaling`.

```
$ lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/AutoScalingMultiAZWithNotifications.template --name autoscaling
Imported raw CloudFormation template and lono-fied it!
Template definition added to ./app/stacks/base.rb.
Params file created to ./config/params/base/autoscaling.txt.
Template downloaded to ./app/templates/autoscaling.yml.
$
```

Template was imported from [CloudFormation Auto Scaling Samples](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c23c48c13b7).  After importing, use `lono inspect summary` to get a quick summary of the template.

```sh
$ lono inspect summary autoscaling
CloudFormation Template Summary:
Parameters:
Required:
  VpcId (AWS::EC2::VPC::Id)
  Subnets (List<AWS::EC2::Subnet::Id>)
  OperatorEMail (String)
  KeyName (AWS::EC2::KeyPair::KeyName)
Optional:
  InstanceType (String) Default: t2.small
  SSHLocation (String) Default: 0.0.0.0/0
Resources:
  2 AWS::AutoScaling::ScalingPolicy
  2 AWS::CloudWatch::Alarm
  1 AWS::AutoScaling::LaunchConfiguration
  1 AWS::ElasticLoadBalancingV2::LoadBalancer
  1 AWS::ElasticLoadBalancingV2::Listener
  1 AWS::ElasticLoadBalancingV2::TargetGroup
  1 AWS::SNS::Topic
  1 AWS::EC2::SecurityGroup
  1 AWS::AutoScaling::AutoScalingGroup
  9 Total
$
```

Fill out the required parameters in `config/params/base/autoscaling.txt`. You can these commands to grab the default VPC and a subnet from it:

```
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId')
SUBNETS=$(aws ec2 describe-subnets | jq -r '.Subnets[].SubnetId' | tr -s '\n' ',' | sed 's/,*$//g')
```

Now update the required parameters:

```
sed "s/VpcId=/VpcId=$VPC/; s/Subnets=/Subnets=$SUBNETS/; s/OperatorEMail=/OperatorEMail=email@domain.com/; s/KeyName=/KeyName=default/;" config/params/base/autoscaling.txt > config/params/base/autoscaling.txt.1
mv config/params/base/autoscaling.txt{.1,}
```

Now launch the stack:

```
lono cfn create autoscaling
```

## Commands Summarized

```sh
TEMPLATE=skeleton lono new autoscaling
cd autoscaling
lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/AutoScalingMultiAZWithNotifications.template --name autoscaling
lono inspect summary autoscaling
cat config/params/base/autoscaling.txt
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId'
vpc-d79753ae)
SUBNET=$(aws ec2 describe-subnets | jq -r '.Subnets[].SubnetId' | sort --random-sort | head -1)
sed "s/VpcId=/VpcId=$VPC/; s/Subnets=/Subnets=$SUBNET/; s/OperatorEMail=/OperatorEMail=email@domain.com/; s/KeyName=/KeyName=default/;" config/params/base/autoscaling.txt > config/params/base/autoscaling.txt.1
mv config/params/base/autoscaling.txt{.1,}
lono cfn create autoscaling --template autoscaling
```
