---
title: Params Layering Support
nav_order: 18
---

## Intro: Common Layers

Params support layering for the `configs/demo/params` folder. Params files are layered if they exist. Let's say you have the following params directory structure:

    configs/demo/params
    ├── base.txt
    ├── development.txt
    └── production.txt

* `base.txt` is always evaluated.
* `development.txt` or `production.txt` is evaluated based on LONO_ENV.

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

## Full Layering: Conventional Requested

Additionally, layering also considers params files that match the stack name. Here is a list of the full layering possibilities.

Description | Path | Comments
--- | --- | ---
base | configs/BLUEPRINT/params/base.txt | always evaluated
env | configs/BLUEPRINT/params/LONO_ENV.txt | evaluated based on `LONO_ENV` value
params level | configs/BLUEPRINT/params/REQUESTED.txt | common evaluated based on REQUESTED
env level | configs/BLUEPRINT/params/LONO_ENV/REQUESTED.txt | generally recommended

The `BLUEPRINT`, `LONO_ENV`, and `TEMPLATE` placeholders are self-explanatory.  `REQUESTED` requires a little more explanation. `REQUESTED` is usually the requested `stack name`.  Here's a concrete example with `stack name`:

    lono cfn deploy my-stack --blueprint demo # REQUESTED=my-stack

The layers would be:

1. configs/demo/params/base.txt
2. configs/demo/params/development.txt
3. configs/demo/params/my-stack.txt
4. configs/demo/params/development/my-stack.txt (recommended)

If you need to use a different param file that does not match the stack name, you can explicitly specify the param file with the `--param` option. Here's an example with the `--param` option. Here `REQUESTED` comes from `--param my-param`:

    lono cfn deploy my-stack --blueprint demo --param my-param # REQUESTED=my-param

These params files are layered on top of the "Common" `base.txt` and `development.txt` layers.

1. configs/demo/params/base.txt
2. configs/demo/params/development.txt
3. configs/demo/params/my-param.txt
4. configs/demo/params/development/my-param.txt (recommended)

## Direct Locations

You can also specify relative and full paths for the `--param` value. Example:

    lono cfn deploy my-stack --blueprint demo --param configs/demo/params/my-param.txt

You can specify params files that exist outside of the lono project too.

    lono cfn deploy my-stack --blueprint demo --param /tmp/my-param.txt

Relative and full paths generally remove the "Conventional" lookups for the layers.  So you'll end up with this:

1. configs/demo/params/base.txt
2. configs/demo/params/development.txt
3. /tmp/my-param.txt

{% include prev_next.md %}
