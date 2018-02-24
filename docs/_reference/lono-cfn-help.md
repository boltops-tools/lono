---
title: lono cfn help [COMMAND]
---

## Usage

    lono cfn help [COMMAND]

## Summary

Describe subcommands or one specific subcommand


## Options

```
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

