---
title: Cidr
categories: intrinsic-function
nav_order: 33
---

The `cidr` method is the CloudFormation [Fn::Cidr](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-cidr.html) equivalent.

## Example Snippet

```ruby
resource(:example_subnet, "AWS::EC2::Subnet",
  assign_ipv6_address_on_creation: "true",
  cidr_block: select("0", cidr(get_att("example_vpc.cidr_block"), "1", "8")),
  vpc_id: ref(:example_vpc)}
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