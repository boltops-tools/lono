---
title: Camelizer
category: conventions
desc: Hash key conventions.
nav_order: 70
---

Lono generates CloudFormation templates from a [DSL]({% link _docs/dsl.md %}).  As a part of the generation process, Lono does not auto-camelize the keys of the CloudFormation template by default.

## Why is auto-camelization turned off by default?

Originally, auto-camelization was turned on by default because it results in more Ruby-ish code.  After running into edge-case bugs from auto-camelization, it was decided to be turned off.  Here are just some examples of edge cases:

Resource | Examples
--- | ---
[AWS::RDS::DBInstance](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-rds-database-instance.html) | DBClusterIdentifier, DBInstanceClass, DBName, PerformanceInsightsKMSKeyId, MultiAZ
[AWS::AutoScaling::AutoScalingGroup](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html) | ServiceLinkedRoleARN, TargetGroupARNs, VPCZoneIdentifier

There are other benefits to disabling auto-camelization:

* It better matches the casing of the original source API.
* There's no difference from the documentation.
* There's less mental-overhead. No need to guess and convert back and forth.
* It is easier to search code. IE: You don't have to worry about searching for both underscore and CamelCase words.
* Ruby syntax highlighting makes properties stand out and makes it easier to spot them in code.

Even though it is less Ruby-ish, it has resulted in more overall productivity.

## Enabling Auto-Camelization

Even though auto-camelization is disabled by default, it can be easily enabled. It can be enabled on both 1) a per-blueprint basis and 2) a DSL method basis.

Each blueprint is actually a gem. The gemspec metadata can be used control the camelizer behavior. Example:

```ruby
Gem::Specification.new do |s|
  s.metadata = { auto_camelize: true }
end
```

Setting | Description
--- | ---
`auto_camelize: true` | Enables camelization on all sections.
`auto_camelize: false` | Disables camelization on all sections.
`auto_camelize: except_resource` | Special value enables auto-camelization on all sections except the Resources section.

Lastly, you can finely control and enable auto-camelization with list of the [Lono DSL methods]({% link _docs/dsl.md %}).

```ruby
Gem::Specification.new do |s|
  s.metadata = { auto_camelize: %w[condition mapping metadata output parameter section transform] }
```

The example turns on camelization for pretty much every [Lono DSL method]({% link _docs/dsl.md %}) except resource.

## Code with Auto-Camelization

The auto-camelized Lono DSL code looks much more Ruby-ish:

```ruby
parameter(:instance_type, default: "t3.micro", description: "InstanceType IE: t3.micro # more t3.small")
resource(:security_group, "AWS::EC2::SecurityGroup",
  group_description: "demo security group",
)
```

It produces:

```yaml
Parameters:
  InstanceType:
    Default: t3.micro
    Description: InstanceType IE: t3.micro # more t3.small
    Type: String
Resources:
  SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: demo security group
```

Be wary of the allure. Though it may look like better code. You'll eventually run into annoying edge cases, and the mental overhead is more than it seems. You'll end up having to convert back and forth between underscore and CamelCase form.

Maybe one day, when the auto-camelization eliminates enough of edge-cases, then auto-camelization may be preferred again.  Until then auto-camelization is strongly recommended to be disabled.

## Overriding Special Cases

If you have turned on camelization. Then you may may need to overrride the camelization processing for some keys This is particularly true for the [resource method](({% link _docs/dsl/resource.md %})).

Underneath the hood, lono uses the [cfn_camelizer gem](https://github.com/tongueroo/cfn_camelizer) to handle camelization. For the most part, CloudFormation keys and properties are camelized exactly as required. However, some properties and keys do not expect the strictly camelized versions.  Here are some more examples of special cases:

Camelized | Actual
--- | ---
Ttl | TTL
MaxReceiveCount | maxReceiveCount
DeadLetterTargetArn | deadLetterTargetArn
DbSubnetGroupName | DBSubnetGroupName
RoleArn | RoleARN

Moreover, some CloudFormation template resources do not expect camelized keys at all under specific parent keys.  An example is [API Gateway ResponseParameters](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions-integration-responseParameters.html). Any structure underneath those keys are left untouched.

The special cases list is here: [cfn_camelizer camelizer.yml](https://github.com/tongueroo/cfn_camelizer/blob/master/lib/camelizer.yml).  If you run into a special case that is not covered by the list, please send in a [pull request](https://github.com/tongueroo/cfn_camelizer/pulls) to help others.

You can also add additional special cases your lono project immediately with a `configs/camelizer.yml`:

```yaml
---
special_keys:
  AnotherSpecialKey: anotherSpecialKey
passthrough_parent_keys:
- DontDoAnythingUnderThisParentKey
```

## Methods Camelization

Methods like [ref]({% link _docs/intrinsic-functions/ref.md %}) and [find_in_map]({% link _docs/intrinsic-functions/ref.md %}) will also camelize the arguments when they are symbols.  For example:

```ruby
InstanceType: ref(:instance_type)
```

Produces:

```yaml
InstanceType:
  Ref: InstanceType
```

When the argument values are Strings, then they are left alone.

Note: Method argument camelization may be removed in the future.

{% include prev_next.md %}
