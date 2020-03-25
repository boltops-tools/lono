---
title: group
nav_text: DSL
desc: You can use the groups key to create Linux/UNIX groups and to assign group IDs.
  The group method maps to the AWS::CloudFormation::Init [groups](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html#aws-resource-init-groups)
  section.
categories: configsets-dsl
order: 2
nav_order: 61
---

{{ page.desc }}

## Example

```ruby
group("groupOne")
group("groupTwo",
  gid: 45,
)
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    groups:
      groupOne: {}
      groupTwo:
        gid: 45
```

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
