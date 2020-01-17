---
title: Walkthrough
nav_order: 4
---

Here's a walkthrough of how lono works that's more detailed than the [Quick Start]({% link quick-start.md %}).

1. You define blueprints that include templates written in a [DSL]({% link _docs/dsl.md %})
2. You generate the templates and verify that they look good
3. You deploy the blueprint's template with [lono cfn deploy](/reference/lono-cfn-deploy/)

## 1. Demo Template DSL

The [lono new]({% link _reference/lono-new.md %}) command creates a lono project structure. Then you use the [lono blueprint new]({% link _reference/lono-blueprint-new.md %}) to generate a demo blueprint. That demo blueprint looks something like this:

{% include demo_template_ruby.md %}

## 2. Generate the Template

You can optionally use [lono generate]({% link _reference/lono-generate.md %}) to generate the templates.

    lono generate demo

It'll generates a CloudFormation template from the DSL and writes it to `output/demo/templates/demo.yml`:

{% include demo_template_output.md %}

## 3. Deploy the Blueprint's Template

When your templates look good, you then use [lono cfn deploy]({% link _reference/lono-cfn-deploy.md %}) to launch the stack:

    lono cfn deploy demo

You can check on the stack in the AWS CloudFormation console:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

That's it!  Hopefully that brief walkthrough helps. 😄

{% include prev_next.md %}
