---
title: lono set_instances update
reference: true
---

## Usage

    lono set_instances update STACK_SET

## Description

Update CloudFormation stack set instances.


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

