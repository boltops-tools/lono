---
title: Blueprints
categories: core
order: 1
nav_order: 10
---

A blueprint is one of the core components of a Lono project.  Blueprints can have many [Templates]({% link _docs/core/templates.md %}).

Here's an example demo blueprint structure:

{% include blueprint-structure/dsl.md %}

Hopefully that gives you a basic idea of a lono blueprint structure.

{% include multiple_templates.md %}

## Blueprint Commands

To create a new blueprint you can use:

    lono blueprint new myblueprint

This creates a `blueprint/myblueprint` folder in your lono project with a starter structure.

To list the projects blueprints:

    lono blueprints

{% include prev_next.md %}
