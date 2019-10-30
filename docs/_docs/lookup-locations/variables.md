---
title: Variables Lookup Locations
nav_order: 52
---

## Simple Locations

By design, [Shared Variables]({% link _docs/configs/shared-variables.md %}) they have a very simple lookup logic. Examples:

    configs/BLUEPRINT/variables/base.rb
    configs/BLUEPRINT/variables/development.rb
    configs/BLUEPRINT/variables/production.rb

The lookup locations are simple because variables are so powerful and affect templates at compile-time.

{% include prev_next.md %}
