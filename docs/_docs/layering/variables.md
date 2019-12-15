---
title: Variables Layering Support
nav_order: 19
---

Variables support layering. Layering is performed on the files in the `configs/demo/variables` folder.  Let's say you have the following variables directory structure:

    configs/demo/variables
    ├── base.rb
    ├── development.rb
    └── production.rb

In this case, you want to define your common variables used for templates in the `base.rb`. Specific environment overrides can be defined in their respective `LONO_ENV` variables file.  For example, let's say we're setting the min and max size of an autoscaling group. We could have something like this:

configs/demo/variables/base.rb:

```ruby
@min_size = 1
@max_size = 1
```

configs/demo/variables/production.rb:

```ruby
@min_size = 10
@max_size = 20
```

Lono will use the `@max_size = 20` parameter value when launching the stack with `LONO_ENV=production`.  Lono will use `@max_size = 1` for all other `LONO_ENV` values.  Example:

    $ lono cfn deploy demo # @max_size = 1
    $ LONO_ENV=production lono cfn deploy demo # @max_size = 20

Remember variables can be used to affect templates at compile-time. Here's the lifecycle flow to see when the compile phase happens. 

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

Depending on how you use variables with layering, you can dramatically simpify your code.

{% include prev_next.md %}
