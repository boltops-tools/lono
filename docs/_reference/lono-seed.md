---
title: lono seed
reference: true
---

## Usage

    lono seed

## Description

Generates starter configs for a blueprint.

## Example

    $ lono seed ecs-asg
    Creating starter config files for ecs-asg
    Starter params created:    configs/ecs-asg/params/development.txt
    $ cat configs/ecs-asg/params/development.txt
    # Required parameters:
    VpcId=vpc-111
    Subnets=subnet-111,subnet-222,subnet-333
    EcsCluster=development
    # Optional parameters:
    # InstanceType=m5.large
    # KeyName=...
    # SshLocation=...
    # TagName=ecs-asg
    $


## Options

```
[--param=PARAM]        # override convention and specify the param file to use
[--template=TEMPLATE]  # override convention and specify the template file to use
```

