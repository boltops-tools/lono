---
title: Select
categories: intrinsic-function
nav_order: 42
---

The `select` method is the CloudFormation [Fn::Select](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-select.html) equivalent.

## Example Snippet

```ruby
resource("Subnet0", "AWS::EC2::Subnet",
  vpc_id: ref("Vpc"),
  cidr_block: select("0", ref("DbSubnetIpBlocks"))
)
```

## Example Output

```yaml
Resources:
  Subnet0:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId:
        Ref: Vpc
      CidrBlock:
        Fn::Select:
        - '0'
        - Ref: DbSubnetIpBlocks
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
