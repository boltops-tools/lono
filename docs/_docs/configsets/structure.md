---
title: Configset Structure
nav_text: Structure
categories: configsets
order: 2
nav_order: 23
---

Here's an example lono configset structure:

```sh
├── lib
│   ├── helpers/
│   ├── configset.rb
│   ├── meta.rb
│   └── variables.rb
└── httpd.gemspec
```

File | Description | Required?
--- | --- | ---
helpers | Where you define custom helpers and extend the configset DSL. | optional
configset.rb | The configset code.  The top-level key should be `AWS::CloudFormation::Init`. | required
meta.rb | Additional meta info about the configset. Supports `depends_on`, to specify other configsets as dependencies. | optional
variables.rb | Predefined variables shipped with the configset. Predefined variables can be overridden with [Configset Variables]({% link _docs/configsets/variables.md %}). | optional
httpd.gemspec | A standard gemspec definition.  Configure things like name and author. | required

## lono configset new

{% include configsets/lono-configset-new.md %}

{% include configsets/example.md %}

## meta.rb depends_on example

Configsets can depend on other configsets. The `depends_on` method allows you to reuse configsets by including them as separate dependencies, instead of copying and pasting the configset code. Example:

lib/meta.rb

```ruby
depends_on "amazon-linux-extras"
```

{% include prev_next.md %}
