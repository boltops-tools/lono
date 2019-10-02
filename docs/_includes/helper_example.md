## Example Helper

You define helpers in the blueprint's `app/helpers` folder as a module.  The module name should be the camelized version of the file name. Here's an example:

app/helpers/ec2_helper.rb:

```ruby
module Ec2Helper
  def ec2_instance(logical_id, props={})
    default = {
      instance_type: "t3.micro",
      image_id: ref(:ami_id),
    }
    props.reverse_merge!(default)

    resource(:instance, "AWS::EC2::Instance", props)
  end

  def security_group(logical_id, props={})
    resource(:security_group, "AWS::EC2::SecurityGroup", props)
  end
end
```

You can use the helper in your templates:

app/templates/demo.rb:

```ruby
ec2_instance(:instance,
  security_group_ids: [get_att("security_group.group_id")]
)
security_group(:security_group,
  group_description: "demo security group",
)
```

