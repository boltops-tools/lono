---
title: lono instances delete
reference: true
---

## Usage

    lono instances delete STACK_SET

## Description

Delete CloudFormation stack set instances.

## Example

    $ lono sets instances delete my-set --accounts 112233445566 --regions us-west-1 us-west-2
    Are you sure you want to delete the my-set instances?
    These stack instances will be deleted:

        accounts: 112233445566
        regions: us-west-1,us-west-2


    Are you sure? (y/N) y
    Stack Instance statuses... (takes a while)
    Stack Instance: account 112233445566 region us-west-1 status CURRENT
    Stack Instance: account 112233445566 region us-west-2 status CURRENT
    Stack Instance: account 112233445566 region us-west-2 status OUTDATED reason User initiated operation
    Stack Instance: account 112233445566 region us-west-1 status OUTDATED reason User initiated operation
    Stack Instance: account 112233445566 region us-west-1 status DELETED
    Stack Instance: account 112233445566 region us-west-2 status DELETED
    Time took to complete stack set operation: 30s
    Stack set operation completed.
    $


## Options

```
[--region-order=one two three]      # region_order
[--failure-tolerance-count=N]       # failure_tolerance_count
[--failure-tolerance-percentage=N]  # failure_tolerance_percentage
[--max-concurrent-count=N]          # max_concurrent_count
[--max-concurrent-percentage=N]     # max_concurrent_percentage
[--accounts=one two three]          # List of accounts to apply stack set to. IE: 112233445566 223344556677
[--regions=one two three]           # List of regions to apply stack set to. IE: us-west-2 us-east-1
[--sure], [--no-sure]               # Skip are you sure prompt
[--all], [--no-all]                 # Delete stack all instances. Overrides --accounts and --regions options
```

