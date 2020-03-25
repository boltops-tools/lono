---
title: user
nav_text: DSL
desc: You can use the users key to create Linux/UNIX users on the EC2 instance. The
  user method maps to the AWS::CloudFormation::Init [users](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html#aws-resource-init-users)
  section.
categories: configsets-dsl
order: 3
nav_order: 62
---

{{ page.desc }}

## Example

```ruby
user("myUser",
  groups: ["groupOne", "groupTwo"],
  uid: "50",
  homeDir: "/tmp",
)
user("bob",
  groups: ["groupOne"],
  uid: "51",
  homeDir: "/home/bob",
)
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    users:
      myUser:
        groups:
        - groupOne
        - groupTwo
        uid: '50'
        homeDir: "/tmp"
      bob:
        groups:
        - groupOne
        uid: '51'
        homeDir: "/home/bob"
```

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
