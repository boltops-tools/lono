---
title: Templates
categories: core
order: 2
nav_order: 13
---

Templates are what you'll be working with mostly.  Templates belong to a [Blueprint]({% link _docs/core/blueprints.md %}) and allow you to write CloudFormation templates with the [Lono DSL]({% link _docs/dsl.md %}).  Templates live in the `BLUEPRINT/app/templates` folder.

    BLUEPRINT
    └── app
        └── templates
            └── demo.rb

The starter `demo.rb` template looks something like this:

{% include demo_template_ruby.md %}

The template gets translated to YAML as part of [lono cfn deploy](/reference/lono-cfn-deploy/) or [lono generate](/reference/lono-generate/).  Here's the example output:

{% include demo_template_output.md %}

{% include multiple_templates.md %}

{% include prev_next.md %}
