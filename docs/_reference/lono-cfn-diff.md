---
title: lono cfn diff STACK
reference: true
---

## Usage

    lono cfn diff STACK

## Summary

diff of newly generated template vs existing template in AWS
## Description

Displays code diff of the generated CloudFormation template locally vs the existing template on AWS. You can set a desired diff viewer by setting the LONO_CFN_DIFF environment variable.

Examples:

    lono cfn diff my-stack


## Options

```
[--verbose], [--no-verbose]     
[--noop], [--no-noop]           
[--template=TEMPLATE]           # override convention and specify the template file to use
[--param=PARAM]                 # override convention and specify the param file to use
[--lono], [--no-lono]           # invoke lono to generate CloudFormation templates
                                # Default: true
[--capabilities=one two three]  # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--iam], [--no-iam]             # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--rollback], [--no-rollback]   # rollback
                                # Default: true
```

