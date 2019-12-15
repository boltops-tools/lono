---
title: lono pro configsets
reference: true
---

## Usage

    lono pro configsets

## Description

Lists available BoltOps Pro configsets

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



