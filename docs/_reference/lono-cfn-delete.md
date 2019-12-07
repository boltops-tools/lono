---
title: lono cfn delete
reference: true
---

## Usage

    lono cfn delete STACK

## Description

Delete a CloudFormation stack.

## Examples

    $ lono cfn delete ec2
    Are you sure you want to want to delete the stack? (y/N)
    y
    Deleted example stack.
    $

Lono prompts you with an "Are you sure?" message before the stack gets deleted.  If you would like to bypass the prompt, you can use the `--sure` flag.

    $ lono cfn delete example --sure
    Deleted example stack.
    $


## Options

```
    [--sure], [--no-sure]           # Skips are you sure prompt
c, [--config=CONFIG]                # override convention and specify both the param and variable file to use
    [--blueprint=BLUEPRINT]         # override convention and specify the template file to use
    [--capabilities=one two three]  # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
    [--iam], [--no-iam]             # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
    [--lono], [--no-lono]           # invoke lono to generate CloudFormation templates
                                    # Default: true
p, [--param=PARAM]                  # override convention and specify the param file to use
    [--rollback], [--no-rollback]   # rollback
                                    # Default: true
    [--tags=key:value]              # Tags for the stack. IE: name:api-web owner:bob
    [--template=TEMPLATE]           # override convention and specify the template file to use
v, [--variable=VARIABLE]            # override convention and specify the variable file to use
    [--wait], [--no-wait]           # Wait for stack operation to complete.
                                    # Default: true
    [--verbose], [--no-verbose]     
    [--noop], [--no-noop]           
```

