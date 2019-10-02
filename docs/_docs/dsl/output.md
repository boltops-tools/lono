---
title: Output
category: dsl
desc: The optional Outputs section declares output values shown in the CloudFormation
  outputs console.
nav_order: 23
---

The `output` method maps to the CloudFormation Template Anatomy [Outputs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html) section.

## Example Snippets

There are 3 forms for conditions.  Here are example snippets:

```ruby
# short form
output(:elb)  # same as output(:elb, "!Ref Elb")
output(:elb2) # same as output(:elb2, "!Ref Elb2")
output(:security_group, get_att("security_group.group_id"))

# medium form
output(:stack_name, value: "!Ref AWS::StackName")

# long form
output(vpc_id: {
  description: "vpc id",
  value: ref("vpc_id"), # same as: value: "!Ref VpcId"
})
```

## Example Outputs

```yaml
Outputs:
  Elb:
    Value:
      Ref: Elb
  Elb2:
    Value:
      Ref: Elb2
  SecurityGroup:
    Value:
      Fn::GetAtt:
      - SecurityGroup
      - GroupId
  StackName:
    Value: "!Ref AWS::StackName"
  VpcId:
    Description: vpc id
    Value:
      Ref: VpcId
```

{% include back_to/dsl.md %}

{% include prev_next.md %}
