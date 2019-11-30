app/templates/demo.rb:

```ruby
description "Demo stack"

parameter("InstanceType", "t3.micro")

mapping("AmiMap",
  "us-east-1": { Ami: "ami-0de53d8956e8dcf80" },
  "us-west-2": { Ami: "ami-061392db613a6357b" }
)

resource("Instance", "AWS::EC2::Instance",
  InstanceType: ref("InstanceType"),
  ImageId: find_in_map("AmiMap", ref("AWS::Region"), "Ami"),
  SecurityGroupIds: [get_att("SecurityGroup.GroupId")],
  UserData: base64(user_data("bootstrap.sh"))
)
resource("SecurityGroup", "AWS::EC2::SecurityGroup",
  GroupDescription: "demo security group",
)

output("Instance")
output("SecurityGroup", get_att("SecurityGroup.GroupId"))
```
