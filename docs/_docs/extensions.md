---
title: Extensions
nav_order: 54
---

Extensions provide a way to share helpers code between lono blueprints.

## Usage Example

Let's say you want to create some helper methods that you want to share between 2 blueprints.  Both blueprints will have some common parameters and resources.  Here are some examples:

sg_extension/lib/sg_extension/helpers/parameters.rb:

```ruby
module SgExtensions::Helpers
  module Parameters
    def security_group_parameters
      parameter_group("AWS::EC2::SecurityGroup") do
        parameter("GroupDescription", demo security group")
      end
    end
  end
end
```

sg_extension/lib/sg_extension/helpers/resources.rb:

```ruby
module SgExtensions::Helpers
  module Resources
    def security_group
      resource("SecurityGroup", "AWS::EC2::SecurityGroup",
        GroupDescription: ref("GroupDescription"),
      )
    end
  end
end
```

In your blueprint you can use the extension like so:

app/blueprints/demo/templates/demo.rb

```ruby
extend_with "sg_extension"
security_group_parameters
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
