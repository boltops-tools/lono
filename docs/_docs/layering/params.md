---
title: Params Layering Support
nav_order: 18
---

## Common Layers

Params support layering for the`configs/demo/params` folder. Params files are layered if they exist.

* `base.txt` is always be evaluated.
* `development.txt` or `production.txt` is evaluated based on LONO_ENV.

Let's say you have the following params directory structure:

    configs/demo/params
    ├── base.txt
    ├── development.txt
    └── production.txt

In this case, you want to define your common params used for templates in the `base.txt` and overrides in `production.txt`. For example, let's say we're setting the min and max size of an autoscaling group. We could have something like this:

configs/demo/params/base.txt:

    InstanceType=t3.micro

configs/demo/params/production.txt:

    InstanceType=m5.large

Lono will use the `InstanceType=m5.large` parameter value when launching the stack with `LONO_ENV=production`.  Lono will use `InstanceType=t3.micro` for all other `LONO_ENV` values.  Example:

    $ lono cfn deploy demo # InstanceType=t3.micro
    $ LONO_ENV=production lono cfn deploy demo # InstanceType=m5.large

Remember params can be used to affect templates at run-time. Here's the lifecycle flow to see when the run-time phase happens.

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

## Conventional Requested

Additionally, you can define params files that conventionally matches what is requested. This is usually the stack name. Lono uses the requested stack name to look up params files in conventional locations and also uses them for layering. Here are the conventional locations in a general form:

Description | Path | Comments
--- | --- | ---
params level | configs/BLUEPRINT/params/REQUESTED.txt | least specific
env level | configs/BLUEPRINT/params/LONO_ENV/REQUESTED.txt | generally recommended
template level | configs/BLUEPRINT/params/LONO_ENV/TEMPLATE/REQUESTED.txt | most specific

The `BLUEPRINT`, `LONO_ENV`, and `TEMPLATE` placeholders are self-explanatory.  `REQUESTED` requires a little more explanation. `REQUESTED` is usually the requested `stack name`.  Here's a concrete example with `stack name`:

    lono cfn deploy my-stack --blueprint demo # REQUESTED=my-stack

The layers would be:

1. configs/demo/params/my-stack.txt
2. configs/demo/params/development/my-stack.txt (recommended)
3. configs/demo/params/development/demo/my-stack.txt

These params files are layered on top of the "Common" `base.txt` and `development.txt` layers.

Here's an example with the `--param` option. Here REQUESTED comes from `--param my-param`:

    lono cfn deploy my-stack --blueprint demo --param my-param # REQUESTED=my-param

These params files are layered on top of the "Common" `base.txt` and `development.txt` files.

1. configs/demo/params/my-stack.txt
2. configs/demo/params/development/my-stack.txt (recommended)
3. configs/demo/params/development/demo/my-stack.txt

Layering allows you to override the locations with the `--param` option. The `--param` option takes higher precedence than `stack name` because it is more explicit.

## Direct Locations

You can also specify the `--param` path directly. Example:

    lono cfn deploy my-stack --blueprint demo --param configs/demo/params/my-param.txt

You can specify params files that exist outside of the lono project too.

    lono cfn deploy my-stack --blueprint demo --param /tmp/my-param.txt

Direct locations take the highest precedence and generally remove the "Conventionally Requested" layers.

{% include prev_next.md %}
