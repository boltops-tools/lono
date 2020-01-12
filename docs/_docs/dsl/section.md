---
title: Section
category: dsl
desc: General way to add a section to the generated CloudFormation template.
nav_order: 45
---

The `section` method provides a general way to add a section to the CloudFormation template.  This is useful in case there's a future CloudFormation section that the lono DSL does not yet support.

## Example Snippets

```ruby
section("Resources",
  "SnsTopic" => {
    Type: "AWS::SNS::Topic",
    Properties: {
      Description: "my desc",
      DisplayName: "my name",
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
