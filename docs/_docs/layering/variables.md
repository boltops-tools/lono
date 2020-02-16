---
title: Variables Layering Support
nav_order: 19
---

## Common Layers

Variables support layering for the`configs/demo/variables` folder. Variables files are layered if they exist.

* `base.rb` is always be evaluated.
* `development.rb` or `production.rb` is evaluated based on LONO_ENV.

Let's say you have the following variables directory structure:

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

## Conventional Requested

Additionally, you can define variables files that conventionally matches what is requested. This is usually the stack name. Lono uses the requested stack name to look up variables files in conventional locations and also uses them for layering. Here are the conventional locations in a general form:

Description | Path | Comments
--- | --- | ---
variables level | configs/BLUEPRINT/variables/REQUESTED.rb | least specific
env level | configs/BLUEPRINT/variables/LONO_ENV/REQUESTED.rb | generally recommended
template level | configs/BLUEPRINT/variables/LONO_ENV/TEMPLATE/REQUESTED.rb | most specific

The `BLUEPRINT`, `LONO_ENV`, and `TEMPLATE` placeholders are self-explanatory.  `REQUESTED` requires a little more explanation. `REQUESTED` is usually the requested `stack name`.  Here's a concrete example with `stack name`:

    lono cfn deploy my-stack --blueprint demo # REQUESTED=my-stack

The layers would be:

1. configs/demo/variables/my-stack.rb
2. configs/demo/variables/development/my-stack.rb (recommended)
3. configs/demo/variables/development/demo/my-stack.rb

These variables files are layered on top of the "Common" `base.rb` and `development.rb` layers.

Here's an example with the `--variable` option. Here REQUESTED comes from `--variable my-variable`:

    lono cfn deploy my-stack --blueprint demo --variable my-variable # REQUESTED=my-variable

These variables files are layered on top of the "Common" `base.rb` and `development.rb` files.

1. configs/demo/variables/my-stack.rb
2. configs/demo/variables/development/my-stack.rb (recommended)
3. configs/demo/variables/development/demo/my-stack.rb

Layering allows you to override the locations with the `--variable` option. The `--variable` option takes higher precedence than `stack name` because it is more explicit.

## Direct Locations

You can also specify the `--variable` path directly. Example:

    lono cfn deploy my-stack --blueprint demo --variable configs/demo/variables/my-variable.rb

You can specify variables files that exist outside of the lono project too.

    lono cfn deploy my-stack --blueprint demo --variable /tmp/my-variable.rb

Direct locations take the highest precedence and generally remove the "Conventionally Requested" layers.

{% include prev_next.md %}
