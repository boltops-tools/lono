---
title: Transform
category: dsl
desc: The optional Transform section specifies one or more macros that AWS CloudFormation
  uses to process your template.
nav_order: 46
---

The `transform` method maps to the CloudFormation Template Anatomy [Transform](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/transform-section-structure.html) section.

## Example Snippet 1

```ruby
transform("MyMacro", "Aws::Serverless")
```

## Outputs

```yaml
Transform:
- MyMacro
- Aws::Serverless
```

## Example Snippet 2

```ruby
transform("MyMacro")
```

## Outputs

```yaml
Transform: MyMacro
```

{% include back_to/dsl.md %}

{% include prev_next.md %}
