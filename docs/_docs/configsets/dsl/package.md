---
title: package
nav_text: DSL
desc: You can use the packages key to download and install pre-packaged applications
  and components. On Windows systems, the packages key supports only the MSI installer.
  The package method maps to the AWS::CloudFormation::Init [packages](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html#aws-resource-init-packages)
  section.
categories: configsets-dsl
order: 1
nav_order: 60
---

{{ page.desc }}

## Example

```ruby
package("yum",
  httpd: [],
  jq: [],
)
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    packages:
      yum:
        httpd: []
        jq: []
```

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
