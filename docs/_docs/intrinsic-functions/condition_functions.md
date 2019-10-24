---
title: Condition Functions
categories: intrinsic-function
nav_order: 37
---

Lono supports [Condition Functions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-conditions.html).  Since most of these function names are Ruby keywords they must be called explictly with `fn::`.

* equals
* fn::and
* fn::if
* fn::not
* fn::or

Examples follow:

## Example: equals

```ruby
condition("UseProdCondition",
  equals(ref("EnvironmentType"), "prod")
)
```

outputs:

```yaml
Conditions:
  UseProdCondition:
    Fn::Equals:
    - Ref: EnvironmentType
    - prod
```

## Example: fn::and

```ruby
condition("MyAndCondition",
  fn::and(equals("sg-mysggroup", ref("ASecurityGroup")), {condition: "SomeOtherCondition"})
)
```

outputs:

```yaml
Conditions:
  MyAndCondition:
    Fn::And:
    - Fn::Equals:
      - sg-mysggroup
      - Ref: ASecurityGroup
    - Condition: SomeOtherCondition
```

## Example: fn:if

```ruby
condition("SecurityGroups",
  fn::if("CreateNewSecurityGroup", ref("NewSecurityGroup"), ref("ExistingSecurityGroup"))
)
```

outputs:

```yaml
Conditions:
  SecurityGroups:
    Fn::If:
    - CreateNewSecurityGroup
    - Ref: NewSecurityGroup
    - Ref: ExistingSecurityGroup
```

## Example: fn:not

```ruby
condition("MyNotCondition",
  fn::not(equals(ref("EnvironmentType"), "prod"))
)
```

outputs:

```yaml
Conditions:
  MyNotCondition:
    Fn::Not:
    - Fn::Equals:
      - Ref: EnvironmentType
      - prod
```

## Example: fn::or

```ruby
condition("MyOrCondition",
  fn::or(equals("sg-mysggroup", ref("ASecurityGroup")), {condition: "SomeOtherCondition"})
)
```

outputs:

```yaml
Conditions:
  MyOrCondition:
    Fn::Or:
    - Fn::Equals:
      - sg-mysggroup
      - Ref: ASecurityGroup
    - Condition: SomeOtherCondition
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
