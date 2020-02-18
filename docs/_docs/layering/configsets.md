---
title: Configsets Layering Support
nav_order: 20
---

## Common Layers

Configsets support layering for the `configs/demo/configsets` folder. Configsets files are layered if they exist.

* `base.rb` is always evaluated.
* `development.rb` or `production.rb` is evaluated based on LONO_ENV.

Let's say you have the following configsets directory structure:

    configs/demo/configsets
    ├── base.rb
    ├── development.rb
    └── production.rb

In this case, you want to define your common configsets used for templates in the `base.rb`. Specific environment overrides can be defined in their respective `LONO_ENV` configsets file.  For example, let's say we're setting the min and max size of an autoscaling group. We could have something like this:

configs/demo/configsets/base.rb:

```ruby
configset("cfn-hup", resource: "Instance")
```

configs/demo/configsets/production.rb:

```ruby
configset("httpd", resource: "Instance")
```

Lono will always use the `cfn-hup` configset, but only the `httpd` for the production environment.

## Conventional Requested

The conventional locations are layered similiarly to how [Params]({% link _docs/layering/params.md %}) and [Variables]({% link _docs/layering/variables.md %}) work.

{% include prev_next.md %}
