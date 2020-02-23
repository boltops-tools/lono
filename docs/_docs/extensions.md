---
title: Extensions
nav_order: 54
---

Extensions provide a way to share helpers code between lono blueprints.

## Usage Example

Let's say you want to create some helper methods that you want to share between 2 blueprints.  Both blueprints will have some common parameters and resources.  Here are some examples:

ec2_extension/lib/ec2_extension/helpers/parameters.rb:

```ruby
module Ec2Extensions::Helpers
  module Parameters
    def ec2_parameters
      parameter_group("AWS::AutoScaling::AutoScalingGroup") do
        parameter("InstanceType", "t3.small")
      end
    end
  end
end
```

ec2_extension/lib/ec2_extension/helpers/resources.rb:

```ruby
module Ec2Extensions::Helpers
  module Resources
    def security_group
      resource("SecurityGroup", "AWS::EC2::SecurityGroup",
        GroupDescription: "demo security group",
      )
    end
  end
end
```

In your blueprint you can use the extension like so:

app/blueprints/demo/templates/demo.rb

```ruby
extend_with "ec2_extension"
ec2_parameters
security_group

# Additional resource not from extension
resource("Instance", "AWS::EC2::Instance",
  InstanceType: ref("InstanceType"),
  ImageId: "ami-061392db613a6357b",
  SecurityGroupIds: [get_att("SecurityGroup.GroupId")],
  UserData: base64(user_data("bootstrap.sh"))
)
```

{% include prev_next.md %}
