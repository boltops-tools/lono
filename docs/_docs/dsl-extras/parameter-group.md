---
title: Parameter Groups
category: dsl-extras
desc: Add to the CloudFormation Metadata Parameter Groups and Parameter Labels.
nav_order: 50
---

[Parameter Groups](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudformation-interface-parametergroup.html) and [Parameter Labels](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudformation-interface-parameterlabel.html) control how parameter form fields are displayed in the CloudFormation Console. This allows you to group parameter form fields in a friendly manner.  They're added to the CloudFormation template under the [Metadata.AWS::CloudFormation::Interface key](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cloudformation-interface.html). The structure looks like this:


```yaml
Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
      -
        Label:
          default: EC2 Instance Settings
        Parameters:
          - InstanceType
          - KeyName
      -
        Label:
          default: Security Group Settings
        Parameters:
          - VpcId
    ParameterLabels:
      InstanceType:
        default: What instance type would you like?
      KeyName:
        default: The ssh keypair used to log into the instance
      VpcId:
        default: Vpc to create the security group in
```

## DSL Method: parameter_group

Lono has a `parameter_group` method that makes it easier to use Parameter Groups and Labels. Example:

```ruby
parameter_group("EC2 Instance Settings") do
  parameter("InstanceType", "t3.micro", Label: "What instance type would you like?")
  parameter("KeyName", Label: "The ssh keypair used to log into the instance")
end

parameter_group("Security Group Settings") do
  parameter("VpcId", Description: "IE: vpc-111", Label: "Vpc to create the security group in")
end
```

This generates:

```yaml
---
Parameters:
  InstanceType:
    Default: t3.micro
    Type: String
  KeyName:
    Type: String
  VpcId:
    Description: 'IE: vpc-111'
    Type: String
Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
    - Label:
        default: EC2 Instance Settings
      Parameters:
      - InstanceType
      - KeyName
    - Label:
        default: Security Group Settings
      Parameters:
      - VpcId
    ParameterLabels:
      InstanceType:
        default: What instance type would you like?
      KeyName:
        default: The ssh keypair used to log into the instance
      VpcId:
        default: Vpc to create the security group in
```

## Lono Seed

The [lono seed]({% link _docs/configuration/lono-seed.md %}) command also uses the information created from the parameter group metadata. It generates a configs file with the parameters grouped in a friendly order.  Example:

    $ lono seed demo
    Creating starter config files for demo
    Generating CloudFormation templates for blueprint demo:
      output/demo/templates/demo.yml
          create  configs/demo/params/development.txt
    $

Here's the contents of the params file.

configs/demo/params/development.txt:

    # Parameter Group: EC2 Instance Settings
    # InstanceType=t3.micro
    KeyName= # (required)

    # Parameter Group: Security Group Settings
    VpcId=vpc-111 # (required)

{% include back_to/dsl-extras.md %}

{% include prev_next.md %}
