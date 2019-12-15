---
title: Blueprint Configsets Lookup Locations
nav_order: 68
---

Blueprint configsets are configured within a blueprint in it's `config/configsets.rb` file.  Example:

app/blueprints/demo/config/configsets.rb:

```ruby
configset("httpd", resource: "Instance")
```

Blueprint configsets are searched for in a few locations. It is similiar to how `LOAD_PATH` works.

Location | Type | Description
--- | --- | ---
BLUEPRINT/app/configsets | blueprint | The blueprint's local configsets
PROJECT/vendor/configsets | vendor | Frozen vendor configsets
gems folder | gem | The gems folder is the location where the configset gem is installed. You can use `bundle show GEM` to reveal the location.
gems folder | materialized | All blueprint configsets and their dependency configset are materialized as gems.

## lono configsets BLUEPRINT command

The [lono configsets BLUEPRINT]({% link _reference/lono-configsets.md %}) command provides a quick way to find out what configsets are used by a specific blueprint.

    $ lono configsets ec2
    Configsets used by ec2 blueprint:
    +-------+----------------------+---------+---------+
    | Name  |         Path         |  Type   |  From   |
    +-------+----------------------+---------+---------+
    | httpd | app/configsets/httpd | project | project |
    +-------+----------------------+---------+---------+
    $

{% include configsets/materialized.md header=true %}

{% include prev_next.md %}
