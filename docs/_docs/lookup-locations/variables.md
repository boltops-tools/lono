---
title: Variables Lookup Locations
nav_order: 49
---

## Simple Locations

By design, [Shared Variables]({% link _docs/configs/shared-variables.md %}) they have a very simple lookup logic. Examples:

    configs/BLUEPRINT/variables/base.rb
    configs/BLUEPRINT/variables/development.rb
    configs/BLUEPRINT/variables/production.rb

The lookup locations are simple because variables are so powerful and affect templates at compile-time.

## Project vs Blueprint Variables

Some blueprints contain starter example variables.  When lono is able to find a project variable file, it will use that instead of any blueprint example variables. Here's an example:

    blueprints/ec2/config/variables/development.rb # will not be used
    configs/ec2/variables/development.rb # will be used

The variables in the blueprint's config folder only get used if you have not created your own project specific one in your `configs/BLUEPRINT` folder.

{% include prev_next.md %}
