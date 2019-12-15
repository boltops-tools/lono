---
title: Condition Functions
categories: intrinsic-function
nav_order: 54
---

Lono supports [Condition Functions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-conditions.html).  Since most of these function names are Ruby keywords they must be called with a bang (!).

* equals
* and!
* if!
* not!
* or!

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

## Example: and!

```ruby
condition("MyAndCondition",
  and!(equals("sg-mysggroup", ref("ASecurityGroup")), {Condition: "SomeOtherCondition"})
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

## Example: if!

```ruby
condition("SecurityGroups",
  if!("CreateNewSecurityGroup", ref("NewSecurityGroup"), ref("ExistingSecurityGroup"))
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

## Example: not!

```ruby
condition("MyNotCondition",
  not!(equals(ref("EnvironmentType"), "prod"))
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

## Example: or!

```ruby
condition("MyOrCondition",
  or!(equals("sg-mysggroup", ref("ASecurityGroup")), {Condition: "SomeOtherCondition"})
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
