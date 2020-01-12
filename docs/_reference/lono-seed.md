---
title: lono seed
reference: true
---

## Usage

    lono seed BLUEPRINT

## Description

Generates starter configs for a blueprint.

## Example

    $ lono seed ecs-asg
    Creating starter config files for ecs-asg
          create  configs/ecs-asg/params/development.txt
    $ cat configs/ecs-asg/params/development.txt
    # Required parameters:
    VpcId=vpc-111 # Find at vpc CloudFormation Outputs
    Subnets=subnet-111,subnet-222,subnet-333 # Find at vpc CloudFormation Outputs
    # Optional parameters:
    # InstanceType=m5.large
    # KeyName=...
    # SshLocation=...
    # EcsCluster=development
    # TagName=ecs-asg-development
    # ExistingIamInstanceProfile=...
    # ExistingSecurityGroups=...
    # EbsVolumeSize=50
    # MinSize=1
    # MaxSize=4
    # MinInstancesInService=2
    # MaxBatchSize=1
    $


## Options

```
[--param=PARAM]        # override convention and specify the param file to use
[--source=SOURCE]      # url or path to file with template
[--template=TEMPLATE]  # override convention and specify the template file to use

Runtime options:
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

