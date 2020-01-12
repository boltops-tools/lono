aws_template_format_version "2010-09-09"
description "Demo stack"

parameter("InstanceType", "t3.micro")

mapping("AmiMap",
  "ap-northeast-1": { Ami: "ami-068a6cefc24c301d2" },
  "ap-northeast-2": { Ami: "ami-0d59ddf55cdda6e21" },
  "ap-south-1":     { Ami: "ami-0ce933e2ae91880d3" },
  "ap-southeast-1": { Ami: "ami-07539a31f72d244e7" },
  "ap-southeast-2": { Ami: "ami-0119aa4d67e59007c" },
  "ca-central-1":   { Ami: "ami-0ff24797826ebbcd5" },
  "eu-central-1":   { Ami: "ami-0d4c3eabb9e72650a" },
  "eu-north-1":     { Ami: "ami-006cda581cf39451b" },
  "eu-west-1":      { Ami: "ami-01f14919ba412de34" },
  "eu-west-2":      { Ami: "ami-05f37c3995fffb4fd" },
  "eu-west-3":      { Ami: "ami-0e9e6ba6d3d38faa8" },
  "sa-east-1":      { Ami: "ami-07820a4443539a2b0" },
  "us-east-1":      { Ami: "ami-00068cd7555f543d5" },
  "us-east-2":      { Ami: "ami-0dacb0c129b49f529" },
  "us-west-1":      { Ami: "ami-0b2d8d1abb76a53d8" },
  "us-west-2":      { Ami: "ami-0c5204531f799e0c6" }
)

resource("Instance", "AWS::EC2::Instance",
  InstanceType: ref("InstanceType"),
  ImageId: find_in_map("AmiMap", ref("AWS::Region"), "Ami"),
  SecurityGroupIds: [get_att("SecurityGroup.GroupId")],
  UserData: base64(sub(user_data("bootstrap.sh")))
)
resource("SecurityGroup", "AWS::EC2::SecurityGroup",
  GroupDescription: "demo security group",
)

output("Instance")
output("SecurityGroup", get_att("SecurityGroup.GroupId"))
