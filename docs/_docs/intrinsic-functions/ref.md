---
title: Ref
categories: intrinsic-function
nav_order: 60
---

The `ref` method is the CloudFormation [Ref](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html) equivalent.

## Example Snippet

```ruby
resource("MyEip", "AWS::EC2::EIP",
  InstanceId: ref("MyEc2Instance")
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
