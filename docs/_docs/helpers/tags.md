---
title: tags Helper
category: helpers
---

The `tags` helper adds several conveniences.

## Convenience Form

Provide tags with a simple hash:

```ruby
tags(Name: "test")
```

And it conveniently generates the typical CloudFormation Tags property structure.

```yaml
Tags:
- Key: Name
  Value: test
```

If you prefer to be explicitly you can provide the standard form also. Example:

```ruby
tags([{Key: "Name", Value: "test"}])
```

## PropagateAtLaunch Special Key

For most resources, the CloudFormation Tags structure is an Array of Hashes with `Key` and `Value` elements. For the [AWS::AutoScaling::AutoScalingGroup TagProperty](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-tags.html), there is an additional required key: `PropagateAtLaunch`.

The `tags` helper method can automatically add `PropagateAtLaunch` key to all the Hash elements.  Example:

```ruby
tags(Name: "test", Env: "development", PropagateAtLaunch: true)
```

Results in:

```yaml
Tags:
- Key: Name
  PropagateAtLaunch: true
  Value: test
- Key: Env
  PropagateAtLaunch: true
  Value: development
```

## Tags Variables Inference

The `tags` helper method can also infer it's value from [variables configs]({% link _docs/configs/shared-variables.md %}).  Example:

configs/demo/variables/develpoment.rb:

```ruby
@tags = {Name: "test", Env: "development"}
```

Then in the template, call `tags` without any arguments to tell it to infer the value from variables.

```ruby
tags
```

This generates

```yaml
Tags:
- Key: Name
  Value: test
- Key: Env
  Value: development
```