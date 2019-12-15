---
title: Core Concepts
nav_order: 11
---

Here are the main Lono concepts:

1. Blueprints
2. Templates
3. Configs: Params and Variables
4. Layering: Params and Variables
5. Helpers

## Blueprints

Essentially, blueprints encapsulate the code that is used to generate CloudFormation templates. Blueprints live in your project's `blueprints` folder or as gems.  Blueprints allow you to add infrastructure components and configure them to fit your needs with [Param]({% link _docs/configs/params.md %}) or [Shared Variables](({% link _docs/configs/shared-variables.md %})) configs files. The blueprint component is covered in detailed at the [Blueprints docs]({% link _docs/core/blueprints.md %}).

## Templates

[Templates]({% link _docs/core/templates.md %}) are CloudFormation templates defined via the [Lono DSL]({% link _docs/dsl.md %}). Templates belong to and a part of a [Blueprint]({% link _docs/core/blueprints.md %}). Shared variables and helpers are available in these template definitions.

## Configs: Params and Variables

[Configs]({% link _docs/core/configs.md %}) are how you can customize the blueprints to fit your needs.  There are 2 types of configs: [Params docs]({% link _docs/configs/params.md %}) and [Variables docs]({% link _docs/configs/shared-variables.md %}). Params allow you to affect the templates at run-time. Variables configs allow you to affect the templates at compile-time.

## Layering: Params and Variables

Lono supports a concept called layering.  Layering is how lono merges multiple files together to produce a final result.  This is useful for building multiple environments. For example, it is common to build a separate production and development environment.  Most of the infrastructure is the same except for a few parts that require specific environment overrides.  Lono's layering ability makes this simple to do.  More info on [Layering Support]({% link _docs/core/layering.md %}).

## Helpers

Helpers methods allow you to extend the core DSL. With [Custom Helpers]({% link _docs/dsl/components/custom-helpers.md %}) you can define your own helpers to create your CloudFormation templates. Lono also comes with some [built-in helper methods]({% link _docs/dsl/components/builtin-helpers.md %}).

{% include prev_next.md %}
