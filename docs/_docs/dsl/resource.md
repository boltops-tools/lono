---
title: Resource
category: dsl
desc: The **required** Resources section declares the AWS resources that you want
  to include in the stack, such as an Amazon EC2 instance or an Amazon S3 bucket.
nav_order: 24
---

The `resource` method maps to the CloudFormation Template Anatomy [Resources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html) section.

## Example Snippets

```ruby
# short form
resource(:instance, "AWS::EC2::Instance",
  instance_type: ref(:instance_type),
  image_id: ref(:image_id),
)

# medium form
resource(:security_group,
  type: "AWS::EC2::SecurityGroup",
  properties: {
    group_description: "demo security group"
  }
)

# long form
resource(sns_topic: {
  type: "AWS::SNS::Topic",
  properties: {
    description: "my topic desc",
    display_name: "my topic name",
  }
})
```

## Example Outputs

```yaml
Resources:
  Instance:
    Type: AWS::EC2::Instance
    Properties:
      instanceType:
        Ref: instanceType
      ImageId:
        Ref: ImageId
  SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: demo security group
  SnsTopic:
    Type: AWS::SNS::Topic
    Properties:
      Description: my topic desc
      DisplayName: my topic name
```

{% include back_to/dsl.md %}

{% include prev_next.md %}