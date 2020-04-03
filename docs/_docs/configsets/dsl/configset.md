---
title: configset
nav_text: DSL
desc: You can use the configset method to build multiple configset blocks within one
  configset. This allow you to better organize large configsets. Also, as noted in
  [AWS::CloudFormation::Init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html),
  cfn-init processes configuration sections in a specific order. So this can also
  be useful if you need to more control over ordering.
categories: configsets-dsl
order: 8
nav_order: 67
---

{{ page.desc }}

The cfn-init processes sections according to the following order [AWS::CloudFormation::Init
](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html):

1. packages
2. groups
3. users
4. sources
5. files
6. commands
7. services

## Example

```ruby
configset("configset-1") do
  command("create-file",
    command: "touch /tmp/test.txt",
    test: "test -e /tmp/test.txt",
  )
end
configset("configset-2") do
  command("uptime-command",
    command: "uptime"
  )
end
```

Generates:

```yaml
---
AWS::CloudFormation::Init:
  configSets:
    default:
    - configset-1
    - configset-2
  configset-1:
    commands:
      001_create-file:
        command: touch /tmp/test.txt
        test: test -e /tmp/test.txt
  configset-2:
    commands:
      001_uptime-command:
        command: uptime
```

Notice, how you do not have to define the `configSets` key. Lono automatically generates `configSets` structure using the order which you declare the `configset` blocks.

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
