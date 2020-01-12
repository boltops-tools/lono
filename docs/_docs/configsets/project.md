---
title: Project Configsets
nav_text: Project
nav_order: 25
---

Project configsets are added by you to your lono project.  There are different ways to create or add a configset.

1. PROJECT/app/configsets - your custom configsets
2. PROJECT/vendor/configsets - third party vendorized configsets
3. PROJECT/Gemfile - third party configsets as gems

{% include configsets/lono-configset-new.md %}

The `vendor/configsets` location provides a way to vendorize third party configsets.

Finally, the Gemfile allows you to use configsets as gems.  Example:

```ruby
gem "httpd", "git@github.com:boltopspro/httpd" # use httpd configset
```

After adding configset, it is available to be used in any template. You can list available configsets with the [lono configsets](https://lono.cloud/reference/lono-configsets/) command.

    $ lono configsets
    Available configsets:
    +-------+----------------------+---------+
    | Name  |         Path         |  Type   |
    +-------+----------------------+---------+
    | httpd | app/configsets/httpd | project |
    +-------+----------------------+---------+
    $

To use the configset in a template, add them to a configs file. Example:

configs/ec2/configsets/base.rb:

    configset("httpd", resource: "Instance")

{% include configsets/cfn-init.md %}

{% include prev_next.md %}
