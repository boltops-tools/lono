---
title: Params Lookup Locations
nav_order: 64
---

Lono supports param files that look like env files as a simple way to define your CloudFormation run-time parameters.

## Lookup Direct Locations

You can specify the `--param` path directly. Example:

    lono cfn deploy my-stack --blueprint demo --param configs/demo/params/my-param.txt

You can also specify params files that exist outside of the lono project.

    lono cfn deploy my-stack --blueprint demo --param /tmp/my-param.txt

Direct locations take the highest precedence. Lono also supports powerful conventional lookup paths, which are covered next.

## Lookup Conventional Locations

You can define params files in different locations. Lono lookups up each of these locations until it finds a params file.

Lono will look up the params file in this order.

1. configs/BLUEPRINT/params/LONO_ENV/TEMPLATE/REQUESTED.txt
2. configs/BLUEPRINT/params/LONO_ENV/REQUESTED.txt (recommended for most cases)
3. configs/BLUEPRINT/params/REQUESTED.txt
4. configs/BLUEPRINT/params/LONO_ENV.txt

To determine what param file to use, lono searches for files at each level of specificity until it finds a file. Lono starts with the level with the most specificity first. It ends with the generic env level, least specific, last.

1. template level (most specific)
2. env level (recommended for most cases)
3. params level
4. params generic env (least specific)

The `BLUEPRINT`, `LONO_ENV`, and `TEMPLATE` are self-explantory. But what is `REQUESTED`?

REQUESTED is either the `--param` value or the stack name.  `--param` takes higher precedence than stack name because it is more explicit. Here's a quick example:

REQUESTED is the `--param` value:

    lono cfn deploy my-stack --blueprint demo --param my-param # REQUESTED=my-param

REQUESTED is the value of the stack name:

    lono cfn deploy my-stack --blueprint demo # REQUESTED=my-stack

## Detailed Examples

### REQUESTED as param

If you run the command:

    lono cfn deploy my-stack --blueprint demo --param my-param

Lono will search for these files:

    configs/demo/params/development/demo/my-param.txt (template level)
    configs/demo/params/development/my-param.txt (env level)
    configs/demo/params/my-param.txt (params level)
    configs/demo/params/development.txt (params generic env)

So if you have only created:

    configs/demo/params/development/my-param.txt (env level)

Lono will use it.  The recommendation is to use the **env level** file.  This allows lono to use different params files based on the Lono.env. When you need to, you can override the param file with the `--param` option.

### REQUESTED as stack name

If you run the command:

    lono cfn deploy my-stack --blueprint demo

Lono will search for these files:

    configs/demo/params/development/demo/my-stack.txt (template level)
    configs/demo/params/development/my-stack.txt (env level)
    configs/demo/params/my-stack.txt (params level)
    configs/demo/params/development.txt (params generic level)

So if you have only created:

    configs/demo/params/development/my-stack.txt

Lono will use it.  This allow lono to launch stack names that match the params files.

## Thanks to Conventions

Thanks to [conventions]({% link _docs/conventions.md %}), the deploy command is greatly simplified. Here's an example. Let's say you have these `configs/demo` files:

    configs/demo/params/development/my-param.txt
    configs/demo/params/development/my-stack.txt
    configs/demo/params/development.txt

Now you can run:

    lono cfn deploy my-stack --blueprint demo # uses my-stack.txt
    lono cfn deploy demo --param my-param     # uses my-param.txt
    lono cfn deploy demo                      # uses development.txt

At the same time, the you can easily override the behavior with `--param`.

## Always Used: base.txt

If `base.txt` exists, it will always be loaded first as part of [Layering]({% link _docs/layering/variables.md %}).

    configs/BLUEPRINT/params/base.txt

{% include lookup-common.md %}

{% include prev_next.md %}
