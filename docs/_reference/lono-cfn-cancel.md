---
title: lono cfn cancel
reference: true
---

## Usage

    lono cfn cancel STACK

## Description

Cancel a CloudFormation stack.

## Examples

    $ lono cfn cancel demo
    Canceling updates to demo.
    Current stack status: UPDATE_IN_PROGRESS
    Canceling stack update.
    Waiting for stack to complete
    01:20:32PM UPDATE_ROLLBACK_IN_PROGRESS AWS::CloudFormation::Stack demo User Initiated
    01:20:44PM UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS AWS::CloudFormation::Stack demo
    01:20:44PM UPDATE_ROLLBACK_COMPLETE AWS::CloudFormation::Stack demo
    Stack rolled back: UPDATE_ROLLBACK_COMPLETE
    Time took for stack deployment: 15s.
    $


## Options

```
[--wait], [--no-wait]        # Wait for stack operation to complete.
                             # Default: true
[--sure], [--no-sure]        # Skip are you sure prompt
[--verbose], [--no-verbose]  
[--noop], [--no-noop]        
```

