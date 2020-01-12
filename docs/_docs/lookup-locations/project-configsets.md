---
title: Project Configsets Lookup Locations
nav_order: 67
---

Project configsets are configured by you in one of the configs/BLUEPRINT/configsets folders.  Example:

configs/demo/configsets/base.rb:

```ruby
configset("httpd", resource: "Instance")
```

Project configsets are searched for in a few locations. It is similiar to how `LOAD_PATH` works.

Location | Type | Description
--- | --- | ---
PROJECT/app/configsets | project | Your project configsets
PROJECT/vendor/configsets | vendor | Frozen vendor configsets
gems folder | gem | The gems folder is the location where the configset gem is installed. You can use `bundle show GEM` to reveal the location.
gems folder | materialized | Configsets that are dependencies of your configsets get materialized into the gems folder also.

## lono configsets command

The [lono configsets]({% link _reference/lono-configsets.md %}) command provides a quick way to find out what configsets are available.

    $ lono configsets
    Project configsets:
    +---------+--------------------------------------------------------------------------------------------+---------+
    |  Name   |                                            Path                                            |  Type   |
    +---------+--------------------------------------------------------------------------------------------+---------+
    | httpd   | app/configsets/httpd                                                                       | project |
    | ruby    | vendor/configsets/ruby                                                                     | vendor  |
    | cfn-hup | /home/ec2-user/.rbenv/versions/2.5.6/lib/ruby/gems/2.5.0/bundler/gems/cfn-hup-fc7d06f81209 | gem     |
    | ssm     | /home/ec2-user/.rbenv/versions/2.5.6/lib/ruby/gems/2.5.0/bundler/gems/ssm-0010ad27249d     | gem     |
    +---------+--------------------------------------------------------------------------------------------+---------+
    $

{% include configsets/materialized.md header=true %}

{% include prev_next.md %}
