---
title: lono summary
reference: true
---

## Usage

    lono summary BLUEPRINT

## Description

Prints summary of CloudFormation templates.

The `lono summary` command helps you quickly understand a CloudFormation template.

## Examples

    $ bundle exec lono summary ec2
    Generating CloudFormation templates for blueprint ec2:
      output/ec2/templates/ec2-old.yml
      output/ec2/templates/ec2-new.yml
    => CloudFormation Template Summary for template ec2-new:
    Required Parameters (0):
      There are no required parameters.
    Optional Parameters (3):
      InstanceType (String) Default: t3.micro
      Subnet (String) Default:
      Vpc (String) Default:
    Resources:
      1 AWS::EC2::Instance
      1 AWS::EC2::SecurityGroup
      2 Total
    => CloudFormation Template Summary for template ec2-old:
    Required Parameters (0):
      There are no required parameters.
    Optional Parameters (3):
      InstanceType (String) Default: t3.micro
      Subnet (String) Default:
      Vpc (String) Default:
    Resources:
      1 AWS::EC2::Instance
      1 AWS::EC2::SecurityGroup
      2 Total
    $

Blog Post also covers this: [lono summary Tutorial Introduction](https://blog.boltops.com/2017/09/18/lono-inspect-summary-tutorial-introduction)


## Options

```
[--source=SOURCE]      # url or path to file with template
[--template=TEMPLATE]  # override convention and specify the template file to use

Runtime options:
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

