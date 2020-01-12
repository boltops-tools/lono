---
title: Variables Lookup Locations
nav_order: 65
---

Lono supports variables files that affect the CloudFormation template at compile-time.

## Lookup Direct Locations

You can specify the `--variable` path directly. Example:

    lono cfn deploy my-stack --blueprint demo --variable configs/demo/variables/my-variable.rb

You can also specify variables files that exist outside of the lono project.

    lono cfn deploy my-stack --blueprint demo --variable /tmp/my-variable.rb

Direct locations take the highest precedence. Lono also supports powerful conventional lookup paths, which are covered next.

## Lookup Locations

You can define variables files in different locations. Lono lookups up each of these locations until it finds a variables file.

Lono will look up the variables file in this order.

1. configs/BLUEPRINT/variables/LONO_ENV/TEMPLATE/REQUESTED.rb
2. configs/BLUEPRINT/variables/LONO_ENV/REQUESTED.rb (recommended for most cases)
3. configs/BLUEPRINT/variables/REQUESTED.rb
4. configs/BLUEPRINT/variables/LONO_ENV.rb

To determine what variable file to use, lono searches for files at each level of specificity until it finds a file. Lono starts with the level with the most specificity first. It ends with the generic env level, least specific, last.

1. template level (most specific)
2. env level (recommended for most cases)
3. variables level
4. variables generic env (least specific)

The `BLUEPRINT`, `LONO_ENV`, and `TEMPLATE` are self-explantory. But what is `REQUESTED`?

REQUESTED is either the `--variable` value or the stack name.  `--variable` takes higher precedence than stack name because it is more explicit. Here's a quick example:

REQUESTED is the `--variable` value:

    lono cfn deploy my-stack --blueprint demo --variable my-variable # REQUESTED=my-variable

REQUESTED is the value of the stack name:

    lono cfn deploy my-stack --blueprint demo # REQUESTED=my-stack

## Detailed Examples

### REQUESTED as variable

If you run the command:

    lono cfn deploy my-stack --blueprint demo --variable my-variable

Lono will search for these files:

    configs/demo/variables/development/demo/my-variable.rb (template level)
    configs/demo/variables/development/my-variable.rb (env level)
    configs/demo/variables/my-variable.rb (variables level)
    configs/demo/variables/development.rb (variables generic env)

So if you have only created:

    configs/demo/variables/development/my-variable.rb (env level)

Lono will use it.  The recommendation is to use the **env level** file.  This allows lono to use different variables files based on the Lono.env. When you need to, you can override the variable file with the `--variable` option.

### REQUESTED as stack name

If you run the command:

    lono cfn deploy my-stack --blueprint demo

Lono will search for these files:

    configs/demo/variables/development/demo/my-stack.rb (template level)
    configs/demo/variables/development/my-stack.rb (env level)
    configs/demo/variables/my-stack.rb (variables level)
    configs/demo/variables/development.rb (variables generic level)

So if you have only created:

    configs/demo/variables/development/my-stack.rb

Lono will use it.  This allow lono to launch stack names that match the variables files.

## Thanks to Conventions

Thanks to [conventions]({% link _docs/conventions.md %}), the deploy command is greatly simplified. Here's an example. Let's say you have these `configs/demo` files:

    configs/demo/variables/development/my-variable.rb
    configs/demo/variables/development/my-stack.rb
    configs/demo/variables/development.rb

Now you can run:

    lono cfn deploy my-stack --blueprint demo # uses my-stack.rb
    lono cfn deploy demo --variable my-variable     # uses my-variable.rb
    lono cfn deploy demo                      # uses development.rb

At the same time, the you can easily override the behavior with `--variable`.

## Always Used: base.rb

If `base.rb` exists, it will always be loaded first as part of [Layering]({% link _docs/layering/variables.md %}).

    configs/BLUEPRINT/variables/base.rb

{% include lookup-common.md %}

{% include prev_next.md %}
