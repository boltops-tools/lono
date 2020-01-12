---
title: Cidr
categories: intrinsic-function
nav_order: 53
---

The `cidr` method is the CloudFormation [Fn::Cidr](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-cidr.html) equivalent.

## Example Snippet

```ruby
resource("ExampleSubnet", "AWS::EC2::Subnet",
  AssignIpv6AddressOnCreation: "true",
  CidrBlock: select("0", cidr(get_att("ExampleVpc.CidrBlock"), "1", "8")),
  VpcId: ref("ExampleVpc")}
)
```

## Example Output

```yaml
Resources:
  ExampleSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      AssignIpv6AddressOnCreation: 'true'
      CidrBlock:
        Fn::Select:
        - '0'
        - Fn::Cidr:
          - Fn::GetAtt:
            - ExampleVpc
            - CidrBlock
          - '1'
          - '8'
      VpcId:
        Ref: ExampleVpc
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
