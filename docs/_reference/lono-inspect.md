---
title: lono inspect
---

Lono inspect is provides commands to help you quickly understand a CloudFormation template. Here are some examples.

### Summarize CloudFormation template

As an example, let's download and summarize the parameters for a CloudFormation template with a typically AutoScaling stack.

```sh
$ lono import https://s3.amazonaws.com/cloudformation-templates-us-east-1/AutoScalingMultiAZWithNotifications.template --name asg
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
```

The above command lists out the required, optional parameters, and number of resources types in a CloudFormation template.

### Dependency Chart

With more complex CloudFormation templates, the dependency can get more difficult to follow.  It is helpful to visualize the dependencies.

```sh
lono import https://s3.amazonaws.com/solutions-reference/aws-waf-security-automations/latest/aws-waf-security-automations.template --name waf
lono inspect depends waf
```

This above command generates a dependency chart.  The command uses the DependsOn attribute specified in each resource to figure this out.  It does not show implied dependencies that CloudFormaton automatically computes for us.

The chart is generated with [Graphviz](http://www.graphviz.org/). To install:

```sh
brew install graphviz
```

<a id="prev" class="btn btn-basic" href="{% link articles.md %}">Back</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
