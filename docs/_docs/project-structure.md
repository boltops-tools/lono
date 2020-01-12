---
title: Project Structure
nav_order: 6
---

A lono project structure looks something like this:

    project
    ├── blueprints
    │   └── demo
    │       └── app
    │           └── templates
    │               └── demo.rb
    ├── configs
    │   ├── demo
    │   │   ├── params
    │   │   │   │── development.txt
    │   │   │   └── production.txt
    │   │   └── variables
    │   │       ├── development.rb
    │   │       └── production.rb
    │   └── settings.yml
    └── output
        └── demo
            ├── params
            │   │── development.json
            │   └── production.json
            └── templates
                └── demo.yml


## Files and Folders

File / Folders  | Description
------------- | -------------
blueprints | Where project blueprints live. [Blueprints]({% link _docs/core/blueprints.md %}) essentially contain code to build CloudFormation templates. They can be configured with `configs`.
configs/demo/params | Where CloudFormation run-time parameters can be defined.  [Parameters]({% link _docs/configs/params.md %}) are defined with env-like files.  These are blueprint specific.
configs/demo/variables | Where Lono shared variables can be defined.  [Shared Variables]({% link _docs/configs/shared-variables.md %}) can be used to affect the way templates are built at compile time. These are blueprint specific.
configs/settings.yml | Lono's behavior can be tailored with [Settings]({% link _docs/configuration/settings.md %}).
output/demo/params | Where the generated CloudFormation parameters files get written to. These are blueprint specific.
output/demo/templates | Where the generated CloudFormation templates get written to. These are blueprint specific.

That hopefully gives you a basic idea of an lono project structure.

## Concepts

There are a few Lono conceptual components like blueprints, templates, params, variables, etc. These are covered in the [Core Concepts]({% link _docs/core.md %}) docs.

## Blueprint Structures

Each blueprint type has it's own directory structure. Refer to each blueprint structure docs:

{% assign docs = site.docs | where: "categories","blueprint-structure" %}
<ul>
  {% for doc in docs -%}
    <li><a href='{{doc.url}}'>{{doc.link_text}}</a></li>
  {% endfor %}
</ul>

{% include prev_next.md %}
