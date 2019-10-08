app/templates/demo.rb:

```ruby
description "Demo stack"

parameter("InstanceType", "t3.micro")

mapping("AmiMap",
  "us-east-1": { ami: "ami-0de53d8956e8dcf80" },
  "us-west-2": { ami: "ami-061392db613a6357b" }
)

resource("Instance", "AWS::EC2::Instance",
  instance_type: ref("InstanceType"),
  image_id: find_in_map("AmiMap", ref("AWS::Region"), :ami),
  security_group_ids: [get_att("SecurityGroup.GroupId")],
  user_data: base64(user_data("bootstrap.sh"))
)
resource("SecurityGroup", "AWS::EC2::SecurityGroup",
  group_description: "demo security group",
)

output("Instance")
output("SecurityGroup", get_att("SecurityGroup.GroupId"))
```
