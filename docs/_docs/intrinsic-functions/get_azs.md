---
title: GetAZs
categories: intrinsic-function
nav_order: 57
---

The `get_azs` method is the CloudFormation [Fn::GetAZs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-getavailabilityzones.html) equivalent.

## Example Snippet

```ruby
resource("MySubnet", "AWS::EC2::Subnet",
  VpcId: ref("Vpc"),
  CidrBlock: "10.0.0.0/24",
  AvailabilityZone: select("0", get_azs(''))
)
```

## Example Output

```yaml
Resources:
  MySubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId:
        Ref: Vpc
      CidrBlock: 10.0.0.0/24
      AvailabilityZone:
        Fn::Select:
        - '0'
        - Fn::GetAZs: ''
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
