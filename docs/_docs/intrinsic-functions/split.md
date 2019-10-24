---
title: Split
categories: intrinsic-function
nav_order: 45
---

The `split` method is the CloudFormation [Fn::Split](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-split.html) equivalent.

## Example Snippet

```ruby
resource("Instance", "AWS::EC2::Instance",
  instance_type: ref("InstanceType"),
  image_id: "ami-0de53d8956e8dcf80",
  security_group_ids: split(",", ref("SecurityGroups"))
)
```

## Example Output

```yaml
Resources:
  Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType:
        Ref: InstanceType
      ImageId: ami-0de53d8956e8dcf80
      SecurityGroupIds:
        Fn::Split:
        - ","
        - Ref: SecurityGroups
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
