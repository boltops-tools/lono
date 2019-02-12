---
title: Condition Functions
categories: intrinsic-function
nav_order: 34
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
condition(:use_prod_condition,
  equals(ref(:environment_type), "prod")
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
condition(:my_and_condition,
  fn::and(equals("sg-mysggroup", ref(:a_security_group)), {condition: "SomeOtherCondition"})
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
condition(:security_groups,
  fn::if(:create_new_security_group, ref(:new_security_group), ref(:existing_security_group))
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
condition(:my_not_condition,
  fn::not(equals(ref(:environment_type), "prod"))
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
condition(:my_or_condition,
  fn::or(equals("sg-mysggroup", ref(:a_security_group)), {condition: "SomeOtherCondition"})
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