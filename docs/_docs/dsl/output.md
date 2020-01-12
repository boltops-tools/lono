---
title: Output
category: dsl
desc: The optional Outputs section declares output values shown in the CloudFormation
  outputs console.
nav_order: 42
---

The `output` method maps to the CloudFormation Template Anatomy [Outputs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html) section.

## Example Snippets

There are 3 forms for conditions.  Here are example snippets:

```ruby
# short form
output("Elb")  # same as output("Elb", ref("Elb"))
output("Elb2") # same as output("Elb2", ref("Elb2"))
output("SecurityGroup", get_att("SecurityGroup.GroupId"))

# medium form
output("StackName", Value: ref("AWS::StackName"))

# long form
output("VpcId" => {
  Description: "vpc id",
  Value: ref("VpcId"),
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
    Value:
      Ref: AWS::StackName
  VpcId:
    Description: vpc id
    Value:
      Ref: VpcId
```

{% include back_to/dsl.md %}

{% include prev_next.md %}
