---
title: Params Layering Support
nav_order: 18
---

## Params Layering

Params support layering. Layering is performed for the `configs/demo/params` folder.  Let's say you have the following params directory structure:

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

Depending on how you use params with layering, you can dramatically simpify your code. 

Note: The parameters layering works similiarly for all location lookups: [Params Lookup Locations]({% link _docs/lookup-locations/params.md %}).

{% include prev_next.md %}
