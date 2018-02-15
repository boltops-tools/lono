# Autoscaling Lono Example

## Usage

Edit `config/params/base/autoscaling.txt` with your desired parameters and then launch the stack:

```sh
lono cfn create autoscaling
```

## How This Example Was Built

First, generate a skeleton starter lono project.

```sh
TEMPLATE=skeleton lono new autoscaling
```

Then import a standard CloudFormation template into lono. The `--name` option is used to name the template `autoscaling`.

```
$ lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/AutoScalingMultiAZWithNotifications.template --name autoscaling
Imported raw CloudFormation template and lono-fied it.
Template definition added to app/stacks/base.rb
Params file created to config/params/base/autoscaling.txt
Template downloaded to app/templates/autoscaling.yml
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

The template was imported from [CloudFormation Auto Scaling Samples](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c23c48c13b7).

A starter `config/params/base/autoscaling.txt` was generated with required parameters emptied and optional parameters commented out.  Inspect it to fill in the required parameters: `cat config/params/base/autoscaling.txt`.

```
$ cat config/params/base/autoscaling.txt
VpcId=
Subnets=
OperatorEMail=
KeyName=
#InstanceType=        # optional
#SSHLocation=         # optional
```

### Filling in the Parameters

You can use the following commands to grab the default VPC and a subnet, and set the values needed for the parameters:

```
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId')
SUBNETS=$(aws ec2 describe-subnets | jq -r '.Subnets[].SubnetId' | tr -s '\n' ',' | sed 's/,*$//g')
EMAIL=email@domain.com
KEY_NAME=email@domain.com
```

Now update the required parameters:

```
sed "s/VpcId=/VpcId=$VPC/; s/Subnets=/Subnets=$SUBNETS/; s/OperatorEMail=/OperatorEMail=$EMAIL/; s/KeyName=/KeyName=$KEY_NAME/;" config/params/base/autoscaling.txt > config/params/base/autoscaling.txt.1
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
cat config/params/base/autoscaling.txt
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId')
SUBNETS=$(aws ec2 describe-subnets | jq -r '.Subnets[].SubnetId' | tr -s '\n' ',' | sed 's/,*$//g')
EMAIL=email@domain.com
KEY_NAME=email@domain.com
sed "s/VpcId=/VpcId=$VPC/; s/Subnets=/Subnets=$SUBNETS/; s/OperatorEMail=/OperatorEMail=$EMAIL/; s/KeyName=/KeyName=$KEY_NAME/;" config/params/base/autoscaling.txt > config/params/base/autoscaling.txt.1
mv config/params/base/autoscaling.txt{.1,}
lono cfn create autoscaling --template autoscaling
```
