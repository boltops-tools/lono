---
title: Mapping
category: dsl
desc: The optional Mappings section matches a key to a corresponding set of named
  values.
nav_order: 23
---

The `mapping` method maps to the CloudFormation Template Anatomy [Mappings](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/mappings-section-structure.html) section.

## Example Snippets

There are 2 forms for mapping.  Here are example snippets:

```ruby
# medium form
mapping("AmiMap",
  "ap-northeast-1": {ami: "ami-084cb340923dc7101"},
  "ap-south-1":     {ami: "ami-0d7805fed18723d71"},
)

# long form
mapping("ImageMap" => {
  "ap-northeast-1": {ami: "ami-084cb340923dc7101"},
  "ap-south-1":     {ami: "ami-0d7805fed18723d71"},
})
```

## Example Outputs

```yaml
Mappings:
  AmiMap:
    ap-northeast-1:
      Ami: ami-084cb340923dc7101
    ap-south-1:
      Ami: ami-0d7805fed18723d71
  ImageMap:
    ap-northeast-1:
      Ami: ami-084cb340923dc7101
    ap-south-1:
      Ami: ami-0d7805fed18723d71
```

Note, the second level keys in the mapping structure do not automatically get camelized because they contain dashes.  Lono uses transform the keys of the Hash structure according so some [Camelize Conventions]({% link _docs/conventions/camelize.md %}).

{% include back_to/dsl.md %}

{% include prev_next.md %}
