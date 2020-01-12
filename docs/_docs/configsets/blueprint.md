---
title: Blueprint Configsets
nav_text: Blueprint
nav_order: 26
---

Blueprint configsets are added by blueprints. This allows blueprint to prepackaged configsets, so you don't have to worry about adding them to your project `configs/BLUEPRINT/configsets` files.

## Example

The blueprint specifies configsets to use in its `config/configsets.rb` file. Example:

app/blueprints/ec2/config/configsets.rb:

```ruby
configset("httpd")
```

This means the ec2 blueprint will use the httpd configset to install and run the httpd server.

## List Blueprint Configsets

Use the [lono configsets BLUEPRINT](/reference/lono-configsets/) command to see what configsets the blueprint will use.

    $ lono configsets ec2
    Configsets used by ec2 blueprint:
    +-------+----------------------+---------+---------+
    | Name  |         Path         |  Type   |  From   |
    +-------+----------------------+---------+---------+
    | httpd | app/configsets/httpd | project | project |
    +-------+----------------------+---------+---------+
    $

## Blueprint Configset Lookup Precedence

The blueprint configset code can be in different locations. It's similar to how `LOAD_PATH` works. The search order for these locations are:

1. BLUEPRINT/app/configsets - prepackaged with the blueprint
2. PROJECT/vendor/configsets - vendorized configset, provides you control over the configset
3. PROJECT/Gemfile - configets as gems, provides you control over the configset
4. MATERIALIZED - materialized as gems. lono downloads and "materializes" the configset if necessary.

This allows blueprint configsets to be overrideable and provides you with more control if necessary.

{% include prev_next.md %}
