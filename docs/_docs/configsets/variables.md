---
title: Configset Variables
nav_text: Variables
categories: configsets
order: 4
nav_order: 27
---

The `configset.yml` is processed as ERB before being loaded into the CloudFormation template.  This allows you to use ERB to refer to variables:

Example:

```yaml
AWS::CloudFormation::Init:
  config:
    packages:
      yum:
        httpd: []
    files:
      "/var/www/html/index.html":
        content: |
<%= indent(@html, 10) %>
    services:
      sysvinit:
       httpd:
        enabled: 'true'
        ensureRunning: 'true'
```

The variable here is `@html`. Note, we're also using the `indent` method to align the YAML content.  We'll cover how to set variables next.

## Configset Predefined Variables

Normally, configsets set predefined variables in their `lib/variables.rb` file.  Example:

app/configsets/httpd/lib/variables.rb:

```ruby
@html =<<-EOL
<h1>configset predefined variables</h1>
<p>Hello there from app/configsets/httpd/lib/variables.rb:</p>
EOL
```

## Overriding Configset Variables

You can override the variables with configset `variables.rb` files in the configs folder. You can override variables globally or locally. Global overrides apply to all configsets used by the blueprint. Local overrides apply to the specifically scoped configset only.

Examples:

1. configs/ec2/configsets/variables.rb - global override for all configsets used in the ec2 blueprint
2. configs/ec2/configsets/httpd/variables.rb - local override, only to the httpd configset

If both global and local variables are set, the local variable takes higher precedence and will be used. It is generally recommended to use local overrides only. Example:

configs/ec2/configsets/httpd/variables.rb

```ruby
@html =<<-EOL
<h1>project variables.rb override</h1>
<p>Hello there from configs/ec2/configsets/httpd/variables.rb</p>
EOL
```

## Inline configset variables

You can also override the configset variables inline, when you configure the configset by setting the `vars` key.  Example:

configs/ec2/configsets/base.rb:

```ruby
configset("httpd", resource: "Instance", vars: {html: "<h2>html custom content</h2>", var1: "foo", var2: "bar"})
```

This makes `@var1`, `@var2`, and `@html` instance variables available in the `configset.yml` definition.

## Configsets Configs are Ruby

Since the configs file is Ruby, you have the full power of Ruby to organize things however you wish. Example:

configs/ec2/configsets/httpd/variables.rb

```ruby
@html = IO.read(File.expand_path("html/index.html", __dir__))
```

configs/ec2/configsets/httpd/html/index.html:

```html
<h2>My html page</h2>
<p>Hello there from configs/ec2/configsets/httpd/html/index.html</p>
```

{% include prev_next.md %}
