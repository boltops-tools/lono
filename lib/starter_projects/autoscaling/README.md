# Autoscaling Lono Example

## Usage

Create a new project.

```
TEMPLATE=autoscaling lono new autoscaling
cd autoscaling
```

Edit `config/params/base/autoscaling.txt` with your desired parameters.  Here are the current contents of `config/params/base/autoscaling.txt`:

```sh
VpcId=
Subnets=
OperatorEMail=
KeyName=
#InstanceType=        # optional
#SSHLocation=         # optional
```


Then launch the stack.

```sh
lono cfn create autoscaling
```

## How This Example Was Originally Built

First, generate a skeleton starter lono project.

```sh
lono new autoscaling
```

Then import a standard CloudFormation template into lono. The `--name` option is used to name the template `autoscaling`.

```
$ lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/AutoScalingMultiAZWithNotifications.template --name autoscaling
=> Imported CloudFormation template and lono-fied it.
Template definition added to app/definitions/base.rb
Params file created to config/params/base/autoscaling.txt
Template downloaded to app/templates/autoscaling.yml
=> CloudFormation Template Summary:
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
Here are contents of the params config/params/base/autoscaling.txt file:
VpcId=
Subnets=
OperatorEMail=
KeyName=
#InstanceType=        # optional
#SSHLocation=         # optional
```

The template was imported from [CloudFormation Auto Scaling Samples](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c23c48c13b7).

A starter `config/params/base/autoscaling.txt` was generated with required parameters emptied and optional parameters commented out.  Fill in the required parameters.

### Filling in the Parameters

You can use the following commands to grab the default VPC and a subnet, and set the values needed for the parameters:

```
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId')
SUBNETS=$(aws ec2 describe-subnets | jq -r '.Subnets[].SubnetId' | tr -s '\n' ',' | sed 's/,*$//g')
EMAIL=email@domain.com
KEY_NAME=default
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
lono new autoscaling
cd autoscaling
lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/AutoScalingMultiAZWithNotifications.template --name autoscaling
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[] | select(.IsDefault == true) | .VpcId')
SUBNETS=$(aws ec2 describe-subnets | jq -r '.Subnets[].SubnetId' | tr -s '\n' ',' | sed 's/,*$//g')
EMAIL=email@domain.com
KEY_NAME=default
sed "s/VpcId=/VpcId=$VPC/; s/Subnets=/Subnets=$SUBNETS/; s/OperatorEMail=/OperatorEMail=$EMAIL/; s/KeyName=/KeyName=$KEY_NAME/;" config/params/base/autoscaling.txt > config/params/base/autoscaling.txt.1
mv config/params/base/autoscaling.txt{.1,}
lono cfn create autoscaling --template autoscaling
```
