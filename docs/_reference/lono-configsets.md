---
title: lono configsets
reference: true
---

## Usage

    lono configsets [BLUEPRINT]

## Description

Lists configsets

## Examples

When the `lono configsets` command is passed the blueprint will list the configsets for the blueprint.

    $ lono configsets ec2
    Configsets used by ec2 blueprint:
    +-------+----------------------+---------+---------+
    | Name  |         Path         |  Type   |  From   |
    +-------+----------------------+---------+---------+
    | httpd | app/configsets/httpd | project | project |
    +-------+----------------------+---------+---------+
    $

When there are no arguments passed to the `lono configsets` command it will list the project configsets.

    $ lono configsets
    Project configsets:
    +-------+------------------------+---------+
    | Name  |          Path          |  Type   |
    +-------+------------------------+---------+
    | httpd | app/configsets/httpd   | project |
    | ruby  | vendor/configsets/ruby | vendor  |
    +-------+------------------------+---------+
    $


## Options

```
[--source=SOURCE]  # url or path to file with template
[--stack=STACK]    # stack name. defaults to blueprint name.

Runtime options:
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

