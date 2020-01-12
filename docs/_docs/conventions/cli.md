---
title: CLI
category: conventions
desc: Stack, blueprint, template, and params conventions.
nav_order: 71
---

Lono follows a set of CLI naming conventions. When followed, this can dramatically shorten lono commands.

## CLI Template Name Convention

These conventions apply to all the `lono cfn` commands: [deploy](https://lono.cloud/reference/lono-cfn-deploy/), [preview](https://lono.cloud/reference/lono-cfn-preview/), etc.

By convention, the blueprint name is the same as the stack name. In turn, the template name is the same as the blueprint name.

* stack - This is a required parameter and is the first CLI parameter.
* blueprint - By convention matches the stack name but can be overridden with `--blueprint`.
* template - By convention matches the blueprint name but can be overridden with `--template`.

For example, the following two commands are the same:

Long-form:

    lono cfn deploy demo --blueprint demo --template demo

Short-form:

    lono cfn deploy demo

## Overriding Conventions

Often you want to create a stack name that is different from the blueprint name. Here's an example of overriding the blueprint name.

    lono cfn deploy my-stack --blueprint demo

## Params

The param value matches the stack name by convention.

* param - By convention matches the stack name but can be overridden with `--param`.

So the command:

    lono cfn deploy my-stack --blueprint demo

Is the same as:

    lono cfn deploy my-stack --blueprint demo --template demo --param my-stack

This allows us to organize the params files in a way that matches the stack name.  Example:

    lono cfn deploy daisy   --blueprint demo
    lono cfn deploy jenkins --blueprint demo

Will use the corresponding config files:

    configs/demo/development/daisy.txt
    configs/demo/development/jenkins.txt

## Params Files Lookup Locations

The param name is used to look up different possible param locations. This is covered in more details here: [Params Lookup Locations]({% link _docs/lookup-locations/params.md %}).

{% include prev_next.md %}
