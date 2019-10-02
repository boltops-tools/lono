---
title: Join
categories: intrinsic-function
nav_order: 40
---

The `join` method is the CloudFormation [Fn::Join](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-join.html) equivalent.

## Example Snippet

```ruby
resource(:instance, "AWS::EC2::Instance",
  instance_type: ref(:instance_type),
  image_id: "ami-0de53d8956e8dcf80",
  tags: tags(name: join("-", ref(:param1), ref(:param2)))
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
      Tags:
      - Key: Name
        Value:
          Fn::Join:
          - "-"
          - - Ref: Param1
            - Ref: Param2
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}