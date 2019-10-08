# Simple Starter Demo Example
aws_template_format_version "2010-09-09"
description "Demo stack"

parameter("InstanceType", "t3.micro")

mapping("AmiMap",
  "ap-northeast-1": { ami: "ami-0f9ae750e8274075b" },
  "ap-northeast-2": { ami: "ami-047f7b46bd6dd5d84" },
  "ap-south-1":     { ami: "ami-0889b8a448de4fc44" },
  "ap-southeast-1": { ami: "ami-0b419c3a4b01d1859" },
  "ap-southeast-2": { ami: "ami-04481c741a0311bbb" },
  "ca-central-1":   { ami: "ami-03338e1f67dae0168" },
  "eu-central-1":   { ami: "ami-09def150731bdbcc2" },
  "eu-north-1":     { ami: "ami-d16fe6af" },
  "eu-west-1":      { ami: "ami-07683a44e80cd32c5" },
  "eu-west-2":      { ami: "ami-09ead922c1dad67e4" },
  "eu-west-3":      { ami: "ami-0451ae4fd8dd178f7" },
  "sa-east-1":      { ami: "ami-0669a96e355eac82f" },
  "us-east-1":      { ami: "ami-0de53d8956e8dcf80" },
  "us-east-2":      { ami: "ami-02bcbb802e03574ba" },
  "us-west-1":      { ami: "ami-0019ef04ac50be30f" },
  "us-west-2":      { ami: "ami-061392db613a6357b" }
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
