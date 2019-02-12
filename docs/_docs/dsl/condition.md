---
title: Condition
category: dsl
desc: The optional Conditions section contains statements that define the circumstances
  under which entities are created or configured.
nav_order: 18
---

The `condition` method maps to the CloudFormation Template Anatomy [Conditions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html) section.

## Example Snippets

There are 2 forms for conditions.  Here are example snippets:

```ruby
# medium form
condition :create_prod_resources, equals(ref(:env_type), "prod")

# medium form with a Fn::Equals example
condition(:create_dev_resources,
  "Fn::Equals": [
    ref(:env_type),
    "dev"
  ]
)

# long form
condition create_stag_resources: {
  "Fn::Equals": [
    {"Ref": "env_type"},
    "stag"
  ]
}
```

## Output

```yaml
Conditions:
  CreateProdResources:
    Fn::Equals:
    - Ref: EnvType
    - prod
  CreateDevResources:
    Fn::Equals:
    - Ref: EnvType
    - dev
  CreateStagResources:
    Fn::Equals:
    - Ref: env_type
    - stag
```

{% include back_to/dsl.md %}

{% include prev_next.md %}