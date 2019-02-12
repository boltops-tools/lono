app/templates/demo.rb:

```ruby
description "Demo stack"

parameter(:instance_type, "t3.micro")

mapping(:ami_map,
  "us-east-1": { ami: "ami-0de53d8956e8dcf80" },
  "us-west-2": { ami: "ami-061392db613a6357b" }
)

resource(:instance, "AWS::EC2::Instance",
  instance_type: ref(:instance_type),
  image_id: find_in_map(:ami_map, ref("AWS::Region"), :ami),
  security_group_ids: [get_att("security_group.group_id")],
  user_data: base64(user_data("bootstrap.sh"))
)
resource(:security_group, "AWS::EC2::SecurityGroup",
  group_description: "demo security group",
)

output(:instance)
output(:security_group, get_att("security_group.group_id"))
```
