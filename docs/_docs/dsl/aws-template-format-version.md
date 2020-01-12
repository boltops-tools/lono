---
title: Format Version
category: dsl
desc: The optional AWSTemplateFormatVersion section identifies the capabilities of
  the template.
nav_order: 37
---

The `aws_template_format_version` method maps to the CloudFormation Template Anatomy [AWSTemplateFormatVersion](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/format-version-structure.html).

# Example Snippet


```ruby
aws_template_format_version "2010-09-09"
```

## Output

```yaml
AWSTemplateFormatVersion: '2010-09-09'
```

{% include back_to/dsl.md %}

{% include prev_next.md %}
