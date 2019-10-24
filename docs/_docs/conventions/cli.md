---
title: CLI
category: conventions
desc: Stack, blueprint, template, and params conventions.
nav_order: 49
---

Lono follows a set of CLI naming conventions. When followed, this dramatically allows lono commands to be shorter.

## CLI Template Name Convention

These conventions apply to all the `lono cfn` commands: `deploy`, `preview`, etc.

By convention, the blueprint name is the same as the stack name. In turn, template name is the same as the blueprint name.  Lastly, the param name will default to the template name.

* stack - This is a required parameter and is the first CLI parameter.
* blueprint - By convention matches the stack name but can be overridden with `--blueprint`.
* template - By convention matches the blueprint name but can be overridden with `--template`.
* param - By convention matches the template name but can be overridden with `--param`.

For example, the following two commands are the same:

Long form:

    lono cfn deploy demo --blueprint demo --template demo --param demo

Short form:

    lono cfn deploy demo

## Overriding Conventions

Often you want to create a stack name that is different from the blueprint name. Here's an example of overriding the blueprint name.

    lono cfn deploy demo-1 --blueprint demo

Remember that the template and parameter will in turn default to the blueprint name. So the command above is the same as:

    lono cfn deploy demo-1 --blueprint demo --template demo --param demo

If you are using different template and param names from the blueprint name, you will have to use the fully explicit form. Here's an example:

    lono cfn deploy mystack-1 --blueprint demo --template ec2 --param large

## Params Files Lookup Locations

What we are setting above with the `--param` option is the param "name". The param name is used to look up different possible param locations. This is covered in more details here: [Params Lookup Locations]({% link _docs/lookup-locations/params.md %}).

{% include prev_next.md %}
