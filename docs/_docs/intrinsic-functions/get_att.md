---
title: GetAtt
categories: intrinsic-function
nav_order: 36
---

The `get_att` method is the CloudFormation [Fn::GetAtt](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-getatt.html) equivalent.

## Example Snippet

```ruby
resource(:my_elb, "AWS::ElasticLoadBalancing::LoadBalancer",
  availability_zones: ["eu-west-1a"],
  listeners: [{
    load_balancer_port: "80",
    instance_port: "80",
    protocol: "HTTP"
  }]
)
resource(:my_elb_ingress_group, "AWS::EC2::SecurityGroup",
  group_description: "ELB ingress group",
  security_group_ingress: [{
    ip_protocol: "tcp",
    from_port: "80",
    to_port: "80",
    source_security_group_owner_id: get_att("my_elb.source_security_group.owner_alias"),
    source_security_group_name: get_att("my_elb.source_security_group.group_name")
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
          - SourceSecurityGroup
          - OwnerAlias
        SourceSecurityGroupName:
          Fn::GetAtt:
          - MyElb
          - SourceSecurityGroup
          - GroupName
```

{% include back_to/intrinsic_functions.md %}

{% include prev_next.md %}