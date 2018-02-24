---
title: lono new NAME
---

## Usage

    lono new NAME

## Summary

generates new CLI project
## Description

Examples:

    lono new infra # skeleton project with barebones structure
    TEMPLATE=ec2 lono new infra # creates a single server
    TEMPLATE=autoscaling lono new infra

For a list of the starter templates:
https://github.com/tongueroo/lono/tree/master/lib/starter_projects


## Options

```
[--force]                  # Bypass overwrite are you sure prompt for existing files.
[--bundle], [--no-bundle]  # Runs bundle install on the project
                           # Default: true
[--git], [--no-git]        # Git initialize the project
                           # Default: true
```

