---
title: Configset DSL
nav_text: DSL
categories: configsets
order: 3
nav_order: 59
---

Configsets can be written with a DSL. The DSL generates the [AWS::CloudFormation::Init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html) YAML structure.  The DSL stays very close to the underlying structure, so there's little mental mapping.

The DSL form is the preferred form because it is generally more maintainable over the long haul. It also easy to extend the DSL with your own [helpers]({% link _docs/configsets/helpers.md %}). Helpers are one of the big reasons it leads to improved maintainability.

## Example

```ruby
package("yum",
  httpd: []
)
file("/var/www/html/index.html",
  content: "<h1>headline</h1>"
)
service("sysvinit",
  httpd: {
    enabled: true,
    ensureRunning: true,
  }
)
```

This generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    packages:
      yum:
        httpd: []
    files:
      "/var/www/html/index.html":
        content: "<h1>headline</h1>"
    services:
      sysvinit:
        httpd:
          enabled: true
          ensureRunning: true
```

## DSL Methods

{% assign docs = site.docs | where: "categories","configsets-dsl" | sort: "order" %}
Method | Description
--- | ---
{% for doc in docs -%}
[{{ doc.title }}]({{ doc.url }}) | {{ doc.desc }}
{% endfor %}

{% include prev_next.md %}
