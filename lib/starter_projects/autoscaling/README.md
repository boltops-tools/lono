# Autoscaling Lono Example

This project was mainly generated to show an example Autoscaling template with lono.

First generate a skeleton starter lono project.

```sh
TEMPLATE=skeleton lono new autoscaling
```

Template was imported from [CloudFormation Auto Scaling Samples](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c23c48c13b7)

The `--name` option is used to rename the template `asg`.

```
$ lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/AutoScalingMultiAZWithNotifications.template --name asg
Imported raw CloudFormation template and lono-fied it!
Template definition added to ./app/stacks/base.rb.
Params file created to ./config/params/base/asg.txt.
Template downloaded to ./app/templates/asg.yml.
$
```

After importing, use `lono inspect summary` to get a quick summary of the template.

```sh
$ lono inspect summary asg
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

Fill out the required parameters in
