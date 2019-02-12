---
title: FindInMap
categories: intrinsic-function
nav_order: 35
---

The `find_in_map` method is the CloudFormation [Fn::FindInMap](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-findinmap.html) equivalent.

## Example Snippet

```ruby
mapping(:ami_map,
  "us-east-1": { ami: "ami-0de53d8956e8dcf80" },
  "us-west-2": { ami: "ami-061392db613a6357b" }
)

resource(:instance, "AWS::EC2::Instance",
  instance_type: ref(:instance_type),
  image_id: find_in_map(:ami_map, ref("AWS::Region"), :ami),
)
```

## Example Output

```yaml
Mappings:
  AmiMap:
    us-east-1:
      Ami: ami-0de53d8956e8dcf80
    us-west-2:
      Ami: ami-061392db613a6357b
Resources:
  Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType:
        Ref: InstanceType
      ImageId:
        Fn::FindInMap:
        - AmiMap
        - Ref: AWS::Region
        - Ami
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}