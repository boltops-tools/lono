---
title: Components
categories: erb
nav_order: 87
---

Lono has a few main conceptual components:

1. Template Definitions
2. Template Views
3. Shared Variables
4. Param Files
5. Helpers

## Template Definitions

The template definitions are defined in the `app/definitions` folder.  Template definitions are:

1. where you specify the template source to use
2. what variables to make available for those specific templates
3. where the output template files should be written to

The template definition component is covered in detailed at the [Template Definitions docs]({% link _docs/erb/definitions.md %}).

## Template Views

Template views are ERB templates that are put together to build the CloudFormation templates. The template views are defined in the `templates` folder.  Variable substitution and partial rendering are both supported and provide a powerful way to build templates.  The template view is covered more detail in the [Template Definitions docs]({% link _docs/erb/definitions.md %}).  Template view helpers are also covered in the [Template Helpers docs]({% link _docs/erb/helpers/builtin-helpers.md %}).

## Shared Variables

Template shared variables are available to all template definition config blocks, template views, and parameters.  The variables are defined in the `config/variables` folder.  The variable configuration component is covered in detailed at the [Shared Variables docs]({% link _docs/configs/shared-variables.md %}).

## Param Files

Param files provide a simple way of building parameters for CloudFormation templates. The param files use a simple `key=value` format like env files. The params are defined in the `params` folder.  More information on param files is available on the [Params docs]({% link _docs/configs/params.md %}).

## Helpers

Helpers are methods that help with the template view processing. Lono comes with several [built-in helper methods]({% link _docs/erb/helpers/builtin-helpers.md %}).  Lono also supports user-defined custom helper methods. With custom helper methods you can define your own helpers to help with the template view processing. More information on custom helpers is available in the [Custom Helpers docs]({% link _docs/erb/helpers/custom-helpers.md %}).

{% include prev_next.md %}
