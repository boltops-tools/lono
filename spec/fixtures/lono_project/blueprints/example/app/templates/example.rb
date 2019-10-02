aws_template_format_version "2010-09-09"
description "Example from BoltOps."

metadata(
  authors: {
    description: "Tung Nguyen (tung@boltops.com)"
  },
)

parameter :key_name
parameter :ecs_cluster, "development"
parameter(:subnets, description: "Comma separated list of subnets")

mapping(:ami_map,
  "us-east-1": {
    ami: "ami-0a6a36557ea3b9859"
  },
  "us-east-2": {
    ami: "ami-0cca5d0eeadc8c3c4"
  }
)

resource(:vpc, "AWS::EC2::VPC",
  cidr_block: "10.30.0.0/16",
  enable_dns_support: "True",
  enable_dns_hostnames: "True",
  tags: [
    {
      key: "Name",
      value: ref(:vpc_name)
    }
  ]
)
resource(:internet_gateway, "AWS::EC2::InternetGateway",
  tags: [
    {
      key: "Name",
      value: ref(:vpc_name)
    }
  ]
)
resource(:gateway_to_internet, "AWS::EC2::VPCGatewayAttachment",
  vpc_id: ref(:vpc),
  internet_gateway_id: ref(:internet_gateway)
)

# tags(name: ref(:vpc_name))
