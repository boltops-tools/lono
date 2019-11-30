## Example Helper

You define helpers in the blueprint's `app/helpers` folder as a module.  The module name should be the camelized version of the file name. Here's an example:

app/helpers/ec2_helper.rb:

```ruby
module Ec2Helper
  def ec2_instance(logical_id, props={})
    default = {
      InstanceType: "t3.micro",
      ImageId: ref("AmiId"),
    }
    props.reverse_merge!(default)

    resource("Instance", "AWS::EC2::Instance", props)
  end

  def security_group(logical_id, props={})
    resource("SecurityGroup", "AWS::EC2::SecurityGroup", props)
  end
end
```

You can use the helper in your templates:

app/templates/demo.rb:

```ruby
ec2_instance("Instance",
  SecurityGroupIds: [get_att("SecurityGroup.GroupId")]
)
security_group("SecurityGroup",
  GroupDescription: "demo security group",
)
```

