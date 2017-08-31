---
title: Components
---

Lono has a few main conceptual components:

1. Template Configurations
2. Shared Variables
3. Template Views
4. Param Files
5. Helpers

### Template Configurations

Template configurations are:

1. where you specify the template source to use
2. what variables to make available for those templates
3. where the output template files should be written to

The template configurations are defined in the `config/templates` folder.  The template configuration component is covered in detailed at the [Template Configurations docs]({% link _docs/config-templates.md %}).

### Shared Variables

Template shared variables are available to all template config blocks and template views.  The variables are defined in the `config/variables` folder.  The variable configuration component is covered in detailed at the [Shared Variables docs]({% link _docs/config-variables.md %}).

### Template Views

Template views are ERB templates that are put together to build the CloudFormation templates. The template views are defined in the `templates` folder.  Variable substitution and partial rendering are both supported and provide a powerful way to build templates.  The template view is covered more detail in the [Template Configurations docs]({% link _docs/config-templates.md %}).  Template view helpers are also covered in the [Template Helpers docs]({% link _docs/template-helpers.md %}).

### Param Files

Param files provide a simple way of building parameters for CloudFormation templates. The param files use a simple `key=value` format like env files. The params are defined in the `params` folder.  More information on param files is available on the [Params docs]({% link _docs/params.md %}).

### Helpers

Helpers are methods that help with the template view procesing. Lono comes with several [built-in helper methods]({% link _docs/template-helpers.md %}).  Lono also supports user-defined custom helper methods. With custom helper methods you can define you own helpers to help with the template view processing. More information on custom helpers is available in the [Custom Helpers docs]({% link _docs/custom-helpers.md %}).

<a id="prev" class="btn btn-basic" href="{% link _docs/docs-start.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/directory-structure.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
