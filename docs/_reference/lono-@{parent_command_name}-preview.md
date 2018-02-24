---
title: lono cfn preview STACK
---

## Usage

    lono cfn preview STACK

## Summary

preview a CloudFormation stack update
## Options

```
[--keep], [--no-keep]           # keep the changeset instead of deleting it afterwards
[--diff], [--no-diff]           # Show diff of the source code template changes also.
                                # Default: true
[--verbose], [--no-verbose]     
[--noop], [--no-noop]           
[--region=REGION]               # AWS region
[--template=TEMPLATE]           # override convention and specify the template file to use
[--param=PARAM]                 # override convention and specify the param file to use
[--lono], [--no-lono]           # invoke lono to generate CloudFormation templates
                                # Default: true
[--capabilities=one two three]  # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--iam], [--no-iam]             # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--rollback], [--no-rollback]   # rollback
                                # Default: true
```

## Description

Generates a CloudFormation preview.  This is similar to a `terraform plan` or puppet's dry-run mode.

Example output:

CloudFormation preview for 'example' stack update. Changes:

Remove AWS::Route53::RecordSet: DnsRecord testsubdomain.sub.tongueroo.com

Examples:

    lono cfn preview my-stack


