---
title: Conditional Parameter
category: dsl-extras
desc: Helps with creating a common pattern of creating a parameter, condition, and
  ref.
nav_order: 48
---

Conditional parameters is a lono concept. It encapsulates a common pattern with the usage of `parameter`, `condition` and `ref`.

Let's say you would like to have an "optional" parameter on an EC2 instance resource. You can try this.

```ruby
parameter("KeyName", Default: "")
resource("Instance", "AWS::EC2::Instance",
  KeyName: ref("KeyName")
)
```

However, this does not work because the `KeyName` is an empty string. The `KeyName` actually needs to exists.

What's needed is for the `KeyName: ref("KeyName")` assignment to be conditional. When a `KeyName` parameter is blank string , the assignment should be `KeyName: ref("AWS::NoValue")`.

## Condition to the Rescue

One way to achieve an "optional" parameter is with a condition. Example:

```ruby
parameter("KeyName", Default: "")
condition("HasKeyName", not!(equals("KeyName", "")))
resource("Instance", "AWS::EC2::Instance",
  KeyName: if!("HasKeyName", ref("KeyName"), ref("AWS::NoValue"))
)
```

This is what a lono conditional parameter is all about.

## Lono Conditional Parameters

Lono conditional parameters encapsulates the `parameter`, `condition`, and `ref` pattern. Here's an example.

```ruby
parameter("KeyName", Conditional: true)
resource("Instance", "AWS::EC2::Instance",
  KeyName: ref("KeyName"), Conditional: true)
)
```

The `Conditional: true` on the `parameter` method results in automatically creating a `condition`:

```ruby
condition("HasKeyName", not!(equals("KeyName", "")))
```

The `Conditional: true` on the `ref` method results in automatically adding the `if` method with `HasKeyName` as the condition and `ref("AWS::NoValue")` as the else value.

For a lot of parameters, using the conditional parameter pattern can really help [DRY]({% link _docs/dry.md %}) up your code.

{% include back_to/dsl-extras.md %}

{% include prev_next.md %}
