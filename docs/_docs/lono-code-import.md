---
title: Lono Code Import
nav_order: 9
---

<div class="video-box"><div class="video-container"><iframe src="https://www.youtube.com/embed/YVU3wPini8U" frameborder="0" allowfullscreen=""></iframe></div></div>

{% include lono-code-excerpt.md %}

The [lono code import](https://lono.cloud/reference/lono-code-import/) command allows you to take JSON or YAML templates and convert it to the Lono DSL code. The conversion process saves you engineering time writing it yourself.

## Usage: lono code import

The [lono code import](https://lono.cloud/reference/lono-code-import/) command will import an existing CloudFormation template and create a blueprint from it. It translates YAML or JSON templates to the Lono Ruby DSL code. It can read from an URL or file. Here's an example:

    $ URL=https://s3.amazonaws.com/cloudformation-templates-us-east-1/EC2InstanceWithSecurityGroupSample.template
    $ lono code import $URL --blueprint ec2
    => Creating new blueprint called ec2.
          create  blueprints/ec2
          create  blueprints/ec2/ec2.gemspec
          create  blueprints/ec2/.gitignore
          create  blueprints/ec2/CHANGELOG.md
          create  blueprints/ec2/Gemfile
          create  blueprints/ec2/README.md
          create  blueprints/ec2/Rakefile
          create  blueprints/ec2/seed/configs.rb
          create  blueprints/ec2/app/templates
          create  blueprints/ec2/app/templates/ec2.rb
          create  configs/ec2/params/development.txt
          create  configs/ec2/params/production.txt
    ================================================================
    Congrats  You have successfully imported a lono blueprint.

    More info: https://lono.cloud/docs/core/blueprints
    $

We're using the EC2 example template from the [AWS CloudFormation Sample Templates docs page](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-sample-templates.html).


Here's a snippet of the converted code:

blueprints/ec2/app/templates/ec2.rb:

```ruby
aws_template_format_version "2010-09-09"
description "AWS CloudFormation Sample Template EC2InstanceWithSecurityGroupSample: Create an Amazon EC2 instance running the Amazon Linux AMI. The AMI is chosen based on the region in which the stack is run. This example creates an EC2 security group for the instance to give you SSH access. **WARNING** This template creates an Amazon EC2 instance. You will be billed for the AWS resources used if you create a stack from this template."
parameter("KeyName",
  Description: "Name of an existing EC2 KeyPair to enable SSH access to the instance",
  Type: "AWS::EC2::KeyPair::KeyName",
  ConstraintDescription: "must be the name of an existing EC2 KeyPair."
)
parameter("InstanceType",
  Description: "WebServer EC2 instance type",
  Default: "t2.small",
  AllowedValues: [
    "t1.micro",
    "t2.nano",
    "t2.micro",
    "t2.small",
    # ...
  ],
)
# ...
mapping("AWSRegionArch2AMI",
  "us-east-1":      { HVM64: "ami-0080e4c5bc078760e", HVMG2: "ami-0aeb704d503081ea6" },
  "us-west-2":      { HVM64: "ami-01e24be29428c15b2", HVMG2: "ami-0fe84a5b4563d8f27" },
  "us-west-1":      { HVM64: "ami-0ec6517f6edbf8044", HVMG2: "ami-0a7fc72dc0e51aa77" },
  # ...
  "cn-northwest-1": { HVM64: "ami-0f7937761741dc640", HVMG2: "NOT_SUPPORTED" }
)
resource("EC2Instance", "AWS::EC2::Instance",
  InstanceType: ref("InstanceType"),
  SecurityGroups: [
    ref("InstanceSecurityGroup")
  ],
  KeyName: ref("KeyName"),
  ImageId: find_in_map("AWSRegionArch2AMI",ref("AWS::Region"),find_in_map("AWSInstanceType2Arch",ref("InstanceType"),"Arch"))
)
resource("InstanceSecurityGroup", "AWS::EC2::SecurityGroup",
  GroupDescription: "Enable SSH access via port 22",
  SecurityGroupIngress: [
    {
      IpProtocol: "tcp",
      FromPort: "22",
      ToPort: "22",
      CidrIp: ref("SSHLocation")
    }
  ]
)
output("InstanceId",
  Description: "InstanceId of the newly created EC2 instance",
  Value: ref("EC2Instance")
)
# ...
output("PublicIP",
  Description: "Public IP address of the newly created EC2 instance",
  Value: get_att("EC2Instance.PublicIp")
)
```

The blueprint structure has also been set up. The import command saves a ton of time.

{% include prev_next.md %}
