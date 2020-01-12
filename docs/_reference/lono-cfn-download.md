---
title: lono cfn download
reference: true
---

## Usage

    lono cfn download STACK

## Description

Download CloudFormation template from existing stack.

## Examples

    lono cfn download my-stack


## Options

```
    [--rollback], [--no-rollback]   # rollback
                                    # Default: true
    [--source=SOURCE]               # url or path to file with template
    [--blueprint=BLUEPRINT]         # override convention and specify the template file to use
    [--capabilities=one two three]  # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
c, [--config=CONFIG]                # override convention and specify both the param and variable file to use
    [--iam], [--no-iam]             # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
p, [--param=PARAM]                  # override convention and specify the param file to use
    [--tags=key:value]              # Tags for the stack. IE: Name:api-web Owner:bob
    [--template=TEMPLATE]           # override convention and specify the template file to use
v, [--variable=VARIABLE]            # override convention and specify the variable file to use
    [--name=NAME]                   # Name you want to save the template as. Default: existing stack name.
    [--verbose], [--no-verbose]     
    [--noop], [--no-noop]           
```

