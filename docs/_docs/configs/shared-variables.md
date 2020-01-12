---
title: Shared Variables
order: 4
nav_order: 16
---

Shared Variables are configs that you define to affect how the templates are generated at compile-time. Shared variables are available to all templates, helpers, and parameters.

## Location

The variables are defined in the `configs/BLUEPRINT/variables` folder.

    configs/
    ├── ecs-spot
    │   └── variables
    │       ├── development.rb
    │       └── production.rb
    └── vpc
        └── variables
            ├── development.rb
            └── production.rb

## Examples

The variables files are merely Ruby scripts where instance variables (variables with an @ sign in front) are made available.

Here's an example:

`config/variables/base.rb`:

```ruby
@ami = "ami-base"
```

The `@ami` variable is now available to all of your templates.

Here's an another example:

`config/variables/production.rb`:

```ruby
@ami = "ami-production"
```

The `@ami = "ami-production"` variable will be used when `LONO_ENV=production`.

Variables allow you to affect the way your templates are built at compile time. This allows doing things that are outside of the ability of run-time parameters. Effective use of shared variables can dramatically shorten down your templates.

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

## Layering Support

Variables also support layering. Layering support is covered in [Layering Support]({% link _docs/core/layering.md %}).

## Variable Lookup Locations

The `LONO_ENV` value is used to look up different possible variable file locations. This is covered in more details here: [Variable Lookup Locations]({% link _docs/lookup-locations/variables.md %}).

{% include prev_next.md %}
