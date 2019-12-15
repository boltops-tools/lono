---
title: GetAtt
categories: intrinsic-function
nav_order: 56
---

The `get_att` method is the CloudFormation [Fn::GetAtt](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-getatt.html) equivalent.

## Example Snippet

```ruby
resource("MyElb", "AWS::ElasticLoadBalancing::LoadBalancer",
  AvailabilityZones: ["eu-west-1a"],
  Listeners: [{
    LoadBalancerPort: "80",
    InstancePort: "80",
    Protocol: "HTTP"
  }]
)
resource("MyElbIngressGroup", "AWS::EC2::SecurityGroup",
  GroupDescription: "ELB ingress group",
  SecurityGroupIngress: [{
    IpProtocol: "tcp",
    FromPort: "80",
    ToPort: "80",
    SourceSecurityGroupOwnerId: get_att("MyElb.SourceSecurityGroup.OwnerAlias"),
    SourceSecurityGroupName: get_att("MyElb.SourceSecurityGroup.GroupName")
  }]
)
```

## Example Output

```yaml
Resources:
  MyElb:
    Type: AWS::ElasticLoadBalancing::LoadBalancer
    Properties:
      AvailabilityZones:
      - eu-west-1a
      Listeners:
      - LoadBalancerPort: '80'
        InstancePort: '80'
        Protocol: HTTP
  MyElbIngressGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: ELB ingress group
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: '80'
        ToPort: '80'
        SourceSecurityGroupOwnerId:
          Fn::GetAtt:
          - MyElb
          - SourceSecurityGroup.OwnerAlias
        SourceSecurityGroupName:
          Fn::GetAtt:
          - MyElb
          - SourceSecurityGroup.GroupName
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}
