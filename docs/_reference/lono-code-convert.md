---
title: lono code convert
reference: true
---

## Usage

    lono code convert SOURCE

## Description

Converts snippet of JSON or YAML CloudFormation templates to Ruby code.

## Examples

    lono code convert path/to/file
    lono code convert http://example.com/url/to/template.yml
    lono code convert http://example.com/url/to/template.json

## Example with Output

    $ lono code convert https://s3-us-east-2.amazonaws.com/cloudformation-templates-us-east-2/AutoScalingMultiAZWithNotifications.template
    INFO: The ruby syntax is valid
    INFO: Translated ruby code below:

    aws_template_format_version "2010-09-09"
    parameter("VpcId",
      Type: "AWS::EC2::VPC::Id",
      Description: "VpcId of your existing Virtual Private Cloud (VPC)",
      ConstraintDescription: "must be the VPC Id of an existing Virtual Private Cloud."
    )
    ...
    ...
    ...
    resource("InstanceSecurityGroup", "AWS::EC2::SecurityGroup",
      GroupDescription: "Enable SSH access and HTTP from the load balancer only",
      SecurityGroupIngress: [
        {
          IpProtocol: "tcp",
          FromPort: "22",
          ToPort: "22",
          CidrIp: ref("SSHLocation")
        },
        {
          IpProtocol: "tcp",
          FromPort: "80",
          ToPort: "80",
          SourceSecurityGroupId: select(0,get_att("ApplicationLoadBalancer.SecurityGroups"))
        }
      ],
      VpcId: ref("VpcId")
    )
    output("URL",
      Description: "The URL of the website",
      Value: join("",[
          "http://",
          get_att("ApplicationLoadBalancer.DNSName")
        ])
    )

The `INFO` messages are written to stderr so you can grab the translated template Ruby code by directing it to a file. Example:

    lono code convert https://s3-us-east-2.amazonaws.com/cloudformation-templates-us-east-2/AutoScalingMultiAZWithNotifications.template > autoscaling.rb
    cat autoscaling.rb

## Lono Pro

This is a lono-pro addon command.


## Options

```
[--casing=CASING]  # Controls casing of logical ids. IE: as-is, camelcase or underscore
                   # Default: as-is
```

