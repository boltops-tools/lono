---
title: Blueprints
categories: core
order: 1
nav_order: 12
---

A blueprint is one of the core components of a Lono project.  Blueprints are essentially CloudFormation templates packaged up in a convenient and reusable way. The CloudFormation code itself lives in the `app/blueprints` folder. This allows you to keep the code [DRY]({% link _docs/dry.md %}). Example:

    app/blueprints
    ├── demo
    └── ec2

Additionally, blueprints can also be gems.  Example:

```ruby
gem "ec2", git: "git@github.com:boltopspro/ec2"
gem "vpc", git: "git@github.com:boltopspro/vpc"
```

Here's an example demo blueprint structure:

{% include blueprint-structure/dsl.md %}

Hopefully, that gives you a basic idea of a lono blueprint structure.

{% include multiple_templates.md %}

## Blueprint Commands

To create a new blueprint you can use:

    lono blueprint new myblueprint

This creates a `app/blueprints/myblueprint` folder in your lono project with a starter structure.

To list the project's blueprints:

    lono blueprints

{% include prev_next.md %}
