<div align="center">
  <img src="https://lono.cloud/img/logos/lono-logo-small.png" />
</div>

# Lono

![CodeBuild](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiYTloZ3dBZkZTYnlTaU1ZZTMvenROM1dmY2lDZzE0MDRVZ2d6NXdqb2JmSXNrQ3pkVGpKRTJMMnhTNDlOYUNOUlZZUmR6TktGcXRWMVFoYzhrSXFZWVZNPSIsIml2UGFyYW1ldGVyU3BlYyI6IkkrSGlFcTBWUjMzbk5xVGYiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
[![CircleCI](https://circleci.com/gh/tongueroo/lono.svg?style=svg)](https://circleci.com/gh/tongueroo/lono)
[![Support](https://img.shields.io/badge/get-support-blue.svg)](https://boltops.com?utm_source=badge&utm_medium=badge&utm_campaign=lono)

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

Lono is a CloudFormation framework. It builds, manages, and deploys CloudFormation templates.

## Lono Features

* Simple CLI interface to launch CloudFormation stacks.
* Ability to use [Existing CloudFormation Templates](https://lono.cloud/docs/existing-templates/).
* [The Lono DSL](https://lono.cloud/docs/dsl/) - Generate templates from beautiful code.
* Write your CloudFormation parameters with [simple env-like values](https://lono.cloud/docs/configs/params/).
* Preview CloudFormation changes before pressing the big red button.
* [Layering](https://lono.cloud/docs/core/layering/) - Allows you to build multiple environments like development and production with the same template.
* [Variables](https://lono.cloud/docs/layering/variables/) - Allows you to construct templates where runtime Parameters do not suffice.
* [Helpers](https://lono.cloud/docs/core/helpers/) - Allows you to extend Lono and simplify code.
* [Configsets](https://lono.cloud/docs/configsets/) - Configurement Management. Automatically configure EC2 instances with reuseable code.

See [lono.cloud](http://lono.cloud) for full lono documentation.

## Upgrading

If you are on version 6 and upgrading to 7.  You can run [lono upgrade](https://lono.cloud/reference/lono-upgrade/) within your project. Refer to the [Upgrading Guide](https://lono.cloud/docs/extras/upgrading/).

## Quick Usage

It only takes a couple of commands to start using lono.

    gem install lono
    lono new infra
    cd infra
    lono blueprint new demo
    lono cfn deploy demo

![Lono flowchart](https://lono.cloud/img/tutorial/lono-flowchart.png "Lono flowchart")

## DSL

Here's an example of what the Lono CloudFormation DSL looks like:

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

### Lono Cfn Deploy

Lono provides a `lono cfn` lifecycle command that allows you to launch stacks quickly.  The `lono cfn deploy` generates and launches the CloudFormation stack.  If you are in a lono project and have a `demo` lono blueprint.  To create a stack run:

    $ lono cfn deploy demo

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
