---
title: Tutorial: Import Template
---

Lono provides a `lono import URL --name NAME` command that makes simple to grab a template and use it in a lono project.  Let's take a look at the [Load-based Auto Scaling CloudFormation sample template](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c23c48c13b7).

### Import

```sh
$ lono new autoscaling
$ cd autoscaling
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

We can seem from the summarized info that 4 parameters are required for to work with this CloudFormation template: `VpcId`, `Subnet`, `OperatorEMail`, and `KeyName`.

### Create the files

Let's create the initial empty files so we can start working on them.

```sh
touch config/templates/base/stacks.rb
touch config/variables/base/variables.rb
touch params/base/single_instance.txt
touch templates/instance.yml.erb
```

Those are the only files needed for a lono project. Next we will add content to the files.

<a id="prev" class="btn btn-basic" href="{% link _docs/tutorial.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial-template-build.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

