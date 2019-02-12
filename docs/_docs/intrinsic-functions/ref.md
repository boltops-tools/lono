---
title: Ref
categories: intrinsic-function
nav_order: 40
---

The `ref` method is the CloudFormation [Ref](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html) equivalent.

## Example Snippet

```ruby
resource(:my_eip, "AWS::EC2::EIP",
  instance_id: ref(:my_ec2_instance)
)
```

## Example Output

```yaml
Resources:
  MyEip:
    Type: AWS::EC2::EIP
    Properties:
      InstanceId:
        Ref: MyEc2Instance
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}