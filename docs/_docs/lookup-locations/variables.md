---
title: Variables Lookup Locations
nav_order: 52
---

## Simple Locations

By design, [Shared Variables]({% link _docs/configs/shared-variables.md %}) they have a very simple lookup logic. The lookup locations are simple because variables are so powerful and affect templates at compile-time.

The general lookup locations are:

    configs/BLUEPRINT/variables/base.rb
    configs/BLUEPRINT/variables/development.rb
    configs/BLUEPRINT/variables/production.rb

## Examples

If you use:

    LONO_ENV=production lono cfn deploy demo

Then lono will use:

    configs/demo/variables/production.rb

## Specify Lookup Location

You can use the `--variable` option to override the default lookup behavior.  Example:

    lono cfn deploy --variable configs/ec2/variables/dev.rb
    lono cfn deploy --variable dev # same as configs/ec2/variables/dev.rb

## Always Used: base.rb

If `base.rb` exists, it will always be loaded first as part of [Layering]({% link _docs/layering/variables.md %}).

    configs/BLUEPRINT/variables/base.rb

{% include prev_next.md %}
