---
title: Sub
categories: intrinsic-function
nav_order: 63
---

The `sub` method is the CloudFormation [Fn::Sub](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-sub.html) equivalent.

## Example Snippet

```ruby
resource("Instance", "AWS::EC2::Instance",
  InstanceType: ref("InstanceType"),
  ImageId: "ami-0de53d8956e8dcf80",
  UserData: sub("hello ${k1} ${k2}", k1: "v1", k2: "v2")
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
      UserData:
        Fn::Sub:
        - hello ${k1} ${k2}
        - k1: v1
          k2: v2
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
