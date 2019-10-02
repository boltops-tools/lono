---
title: Section
category: dsl
desc: General way to add a section to the generated CloudFormation template.
nav_order: 26
---

The `section` method provides a general way to add a section to the CloudFormation template.  This is useful in case there's a future CloudFormation section that the lono DSL does not yet support.

## Example Snippets

```ruby
section(:resources,
  sns_topic: {
    type: "AWS::SNS::Topic",
    properties: {
      description: "my desc",
      display_name: "my name",
    }
  }
)
```

## Example Outputs

```yaml
Resources:
  SnsTopic:
    Type: AWS::SNS::Topic
    Properties:
      DisplayName: my name
```

{% include back_to/dsl.md %}

{% include prev_next.md %}
