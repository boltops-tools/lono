---
title: Variables Layering Support
nav_order: 19
---

## Intro: Common Layers

Variables support layering for the `configs/demo/variables` folder. Variables files are layered if they exist. Let's say you have the following variables directory structure:

    configs/demo/variables
    ├── base.rb
    ├── development.rb
    └── production.rb

* `base.rb` is always evaluated.
* `development.rb` or `production.rb` is evaluated based on LONO_ENV.

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

Lono will use the `@max_size = 20` variableeter value when launching the stack with `LONO_ENV=production`.  Lono will use `@max_size = 1` for all other `LONO_ENV` values.  Example:

    $ lono cfn deploy demo # @max_size = 1
    $ LONO_ENV=production lono cfn deploy demo # @max_size = 20

Remember variables can be used to affect templates at compile-time. Here's the lifecycle flow to see when the compile phase happens.

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

Depending on how you use variables with layering, you can dramatically simpify your code.

## Full Layering: Conventional Requested

Additionally, layering also considers variables files that match the stack name. Here is a list of the full layering possibilities.

Description | Path | Comments
--- | --- | ---
base | configs/BLUEPRINT/variables/base.rb | always evaluated
env | configs/BLUEPRINT/variables/LONO_ENV.rb | evaluated based on `LONO_ENV` value
variables level | configs/BLUEPRINT/variables/REQUESTED.rb | common evaluated based on REQUESTED
env level | configs/BLUEPRINT/variables/LONO_ENV/REQUESTED.rb | generally recommended

The `BLUEPRINT`, `LONO_ENV`, and `TEMPLATE` placeholders are self-explanatory.  `REQUESTED` requires a little more explanation. `REQUESTED` is usually the requested `stack name`.  Here's a concrete example with `stack name`:

    lono cfn deploy my-stack --blueprint demo # REQUESTED=my-stack

The layers would be:

1. configs/demo/variables/base.rb
2. configs/demo/variables/development.rb
3. configs/demo/variables/my-stack.rb
4. configs/demo/variables/development/my-stack.rb (recommended)

If you need to use a different variable file that does not match the stack name, you can explicitly specify the variable file with the `--variable` option. Here's an example with the `--variable` option. Here `REQUESTED` comes from `--variable my-variable`:

    lono cfn deploy my-stack --blueprint demo --variable my-variable # REQUESTED=my-variable

These variables files are layered on top of the "Common" `base.rb` and `development.rb` layers.

1. configs/demo/variables/base.rb
2. configs/demo/variables/development.rb
3. configs/demo/variables/my-variable.rb
4. configs/demo/variables/development/my-variable.rb (recommended)

## Direct Locations

You can also specify relative and full paths for the `--variable` value. Example:

    lono cfn deploy my-stack --blueprint demo --variable configs/demo/variables/my-variable.rb

You can specify variables files that exist outside of the lono project too.

    lono cfn deploy my-stack --blueprint demo --variable /tmp/my-variable.rb

Relative and full paths generally remove the "Conventional" lookups for the layers.  So you'll end up with this:

1. configs/demo/variables/base.rb
2. configs/demo/variables/development.rb
3. /tmp/my-variable.rb

{% include prev_next.md %}
