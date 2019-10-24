---
title: Metadata
category: dsl
desc: The optional Mappings section matches a key to a corresponding set of named
  values.
nav_order: 24
---

The `metadata` method maps to the CloudFormation Template Anatomy [Metadata](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/metadata-section-structure.html) section.

## Example Snippet

```ruby
metadata(
  authors: { description: "Tung Nguyen (tongueroo@gmail.com)" },
  license: "MIT"
)
```

## Example Outputs

```yaml
Metadata:
  Authors:
    Description: Tung Nguyen (tongueroo@gmail.com)
  License: MIT
```

{% include back_to/dsl.md %}

{% include prev_next.md %}
