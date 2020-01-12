---
title: Blueprint Structure
link_text: ERB Blueprint Structure
categories: erb blueprint-structure
nav_order: 86
---

A ERB blueprint structure can look like this:

    demo
    ├── app
    │   ├── definitions
    │   │   │── base.rb
    │   │   │── development.rb
    │   │   └── production.rb
    │   ├── helpers
    │   ├── partials
    │   ├── scripts
    │   ├── templates
    │   │   └── ec2.yml
    │   └── user_data
    ├── demo.gemspec
    ├── Gemfile
    ├── .meta
    │   └── config.yml
    └── setup
        └── configs.rb

### Folders Overview

File / Directory  | Description
------------- | -------------
app/definitions | Here's where you define or declare your template definitions. It tells lono what templates to generate to the `output` folder.  You can specify the template output name and the source template to use here. The templates are [automatically layered together]({% link _docs/core/layering.md %}) based on `LONO_ENV`.  The template blocks are covered in more detail in [templates configuration]({% link _docs/erb/definitions.md %}).
app/helpers | Define your custom helpers here. The custom helpers are made available to `erb/definitions`, `app/templates`, and `config/parameters`. Helpers are covered in detail in [custom helpers]({% link _docs/erb/helpers/custom-helpers.md %}).
app/partials | Where templates partials go. You can split up the CloudFormation templates into erb partials. Include them with the `partial` helper, covered in [built-in helpers]({% link _docs/erb/helpers/builtin-helpers.md %})
app/scripts | Where your custom scripts go. Scripts in this folder get uploaded to s3 as a tarball during the [lono cfn deploy](/reference/lono-cfn-deploy/) command. Details are in the [App Scripts docs]({% link _docs/erb/app-scripts.md %})
app/user_data | Where you place your scripts meant to be used for user-data. Include them in your templates with the `user_data` helper method.
demo.gemspec | Where the gem specs and dependencies are defined.  Blueprints make use of the gem structure to handle dependencies.
seed/configs.rb | Where a setup script can be defined to work with `lono seed`.

That hopefully gives you a basic idea of the blueprint directory structure.

{% include prev_next.md %}
