---
title: Blueprint Lookup Locations
nav_order: 66
---

Blueprints encapsulation CloudFormation templates in a convenient and reusable way.  Blueprints are searched for in a few locations. It is similiar to how `LOAD_PATH` works.

Location | Type | Description
--- | --- | ---
PROJECT/app/blueprints | project | Your project blueprints
PROJECT/vendor/blueprints | vendor | Frozen vendor blueprints
gems folder | gem | The gems folder is the location where the blueprint gem is installed. You can use `bundle show  GEM` to reveal the location.

## lono blueprints command

The [lono blueprints]({% link _reference/lono-blueprints.md %}) command provides a quick way to find out what blueprints are available.

    $ lono blueprints
    Available blueprints:
    +--------+-------------------------------------------------------------------------------------------+---------+
    |  Name  |                                           Path                                            |  Type   |
    +--------+-------------------------------------------------------------------------------------------+---------+
    | demo   | app/blueprints/demo                                                                       | project |
    | ec2    | vendor/blueprints/ec2                                                                     | vendor  |
    | aurora | /home/ec2-user/.rbenv/versions/2.5.6/lib/ruby/gems/2.5.0/bundler/gems/aurora-ab338891588b | gem     |
    +--------+-------------------------------------------------------------------------------------------+---------+
    $

{% include prev_next.md %}
