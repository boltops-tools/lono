---
title: ImportValue
categories: intrinsic-function
nav_order: 58
---

The `import_value` method is the CloudFormation [Fn::ImportValue](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-importvalue.html) equivalent.

## Example Snippet

```ruby
resource("Instance", "AWS::EC2::Instance",
  InstanceType: ref("InstanceType"),
  ImageId: "ami-0de53d8956e8dcf80",
  NetworkInterfaces: {
    GroupSet: [import_value(sub("${NetworkStack}-SecurityGroupID"))],
    AssociatePublicIpAddress: "true",
    DeviceIndex: "0",
    DeleteOnTermination: "true",
    SubnetId: import_value(sub("${NetworkStack}-SubnetID"))
  }
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
      NetworkInterfaces:
        GroupSet:
        - Fn::ImportValue:
            Fn::Sub:
            - "${NetworkStack}-SecurityGroupID"
            - {}
        AssociatePublicIpAddress: 'true'
        DeviceIndex: '0'
        DeleteOnTermination: 'true'
        SubnetId:
          Fn::ImportValue:
            Fn::Sub:
            - "${NetworkStack}-SubnetID"
            - {}
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
