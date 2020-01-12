---
title: lono cfn delete
reference: true
---

## Usage

    lono cfn delete STACK

## Description

Delete CloudFormation stack.

## Examples

    $ lono cfn delete ec2
    Are you sure you want to delete the stack? (y/N)
    y
    Deleted example stack.
    $

Lono prompts you with an "Are you sure?" message before the stack gets deleted.  If you would like to bypass the prompt, you can use the `--sure` flag.

    $ lono cfn delete example --sure
    Deleted example stack.
    $


## Options

```
[--wait], [--no-wait]        # Wait for stack operation to complete.
                             # Default: true
[--sure], [--no-sure]        # Skip are you sure prompt
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
```

