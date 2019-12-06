---
title: Variables Lookup Locations
nav_order: 52
---

Lono supports variables files that affect the CloudFormation template at compile-time.

## Lookup Locations

You can define variables files in different locations. Lono lookups up each of these locations until it finds a variables file.

Lono will look up the variables file in this order.

1. configs/BLUEPRINT/variables/LONO_ENV/TEMPLATE/REQUESTED.txt
2. configs/BLUEPRINT/variables/LONO_ENV/REQUESTED.txt (recommended for most cases)
3. configs/BLUEPRINT/variables/REQUESTED.txt
4. configs/BLUEPRINT/variables/LONO_ENV.txt

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

### REQUESTED as param

If you run the command:

    lono cfn deploy my-stack --blueprint demo --variable my-variable

Lono will search for these files:

    configs/demo/variables/development/demo/my-variable.txt (template level)
    configs/demo/variables/development/my-variable.txt (env level)
    configs/demo/variables/my-variable.txt (params level)
    configs/demo/variables/development.txt (params generic env)

So if you have only created:

    configs/demo/variables/development/my-variable.txt (env level)

Lono will use it.  The recommendation is to use the **env level** file.  This allows lono to use different params files based on the Lono.env. When you need to, you can override the param file with the `--variable` option.

### REQUESTED as stack name

If you run the command:

    lono cfn deploy my-stack --blueprint demo

Lono will search for these files:

    configs/demo/variables/development/demo/my-stack.txt (template level)
    configs/demo/variables/development/my-stack.txt (env level)
    configs/demo/variables/my-stack.txt (params level)
    configs/demo/variables/development.txt (params generic level)

So if you have only created:

    configs/demo/variables/development/my-stack.txt

Lono will use it.  This allow lono to launch stack names that match the params files.

## Thanks to Conventions

Thanks to [conventions]({% link _docs/conventions.md %}), the deploy command is greatly simplified. Here's an example. Let's say you have these `configs/demo` files:

    configs/demo/variables/development/my-variable.txt
    configs/demo/variables/development/my-stack.txt
    configs/demo/variables/development.txt

Now you can run:

    lono cfn deploy my-stack --blueprint demo # uses my-stack.txt
    lono cfn deploy demo --variable my-variable     # uses my-variable.txt
    lono cfn deploy demo                      # uses development.txt

At the same time, the you can easily override the behavior with `--variable`.

## Always Used: base.rb

If `base.rb` exists, it will always be loaded first as part of [Layering]({% link _docs/layering/variables.md %}).

    configs/BLUEPRINT/variables/base.rb

{% include lookup-common.md %}

{% include prev_next.md %}
