---
title: Walkthrough
nav_order: 3
---

Here's a brief walkthrough of how lono works.

1. You define blueprints that include templates written in a [DSL]({% link _docs/dsl.md %})
2. You generate the templates and verify that they look good
3. You deploy the blueprint's template with `lono cfn deploy`

## 1. Demo Template DSL

The `lono new` command creates a lono project structure that includes a demo blueprint. That demo blueprint looks something like this:

{% include demo_template_ruby.md %}

## 2. Generate the Template

When you run:

    lono generate

It'll generates a CloudFormation template from the DSL and writes it to `output/demo/templates/demo.yml`:

{% include demo_template_output.md %}

## 3. Deploy the Blueprint's Template

When your templates look good, then you can deploy them with:

    lono cfn deploy demo

Note, the `lono cfn deploy` command automatically calls `lono generate` so you don't have to worry about regenerating the template. You can check on the stack on the AWS CloudFormation console:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

That's it!  Hopefully that brief walkthrough helps. 😄

{% include prev_next.md %}
