---
title: Lono Code Convert
---

Lono features a [powerful DSL]({% link _docs/dsl.md %}) to build CloudFormation templates. The Lono DSL builds on top of the CloudFormation declarative nature and allows you to deliver Infrastructure as Code. The Lono DSL results in more maintainable code.

Most CloudFormation templates in the wild are written in JSON or YAML though.

The [lono code convert](https://lono.cloud/reference/lono-code-convert/) and [lono code import](https://lono.cloud/reference/lono-code-import/) commands allow you to take JSON or YAML templates and convert it to the Lono DSL code. The conversion process saves you engineering time writing it yourself.

Currently, the lono-pro addon is available at no cost. In the future, access will be provided to only BoltOps Pro customers.

## Installation

The lono-pro addon gem provides extra commands like `lono code convert`. To install it, you can add it to your Gemfile.

```ruby
gem "lono-pro"
```

Or you can install it with the gem command.

    gem install lono-pro

To check the installed version run `lono -v`:

    $ lono -v
    Lono: 5.2.4
    Lono Pro Addon: 0.4.5
    $

## Usage: lono code convert

The `convert` commmand will convert snippets of template code to Ruby code. Here's an example:

template.yml:

```yaml
Resources:
  Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType:
        Ref: InstanceType
      ImageId:
        Fn::FindInMap:
        - AmiMap
        - Ref: AWS::Region
        - Ami
      SecurityGroupIds:
      - Fn::GetAtt:
        - SecurityGroup
        - GroupId
      UserData:
        Fn::Base64: |-
          #!/bin/bash
          echo "hello world"
  SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: demo security group
```

Here's an example running convert on the `template.yml`:

    $ lono code convert template.yml > template.rb
    INFO: The ruby syntax is valid
    INFO: Translated ruby code below:

    $ ruby -c template.rb
    Syntax OK
    $

The INFO messages are written to stderr and the Ruby code output is written to stdout. We're using bash direction write to `template.rb`. Here's what `template.rb` looks like

```ruby
resource("Instance", "AWS::EC2::Instance",
  instance_type: ref("InstanceType"),
  image_id: find_in_map("AmiMap",ref("AWS::Region"),"Ami"),
  security_group_ids: [
    get_att("SecurityGroup","GroupId")
  ],
  user_data: base64("#!/bin/bash\necho \"hello world\"")
)
resource("SecurityGroup", "AWS::EC2::SecurityGroup",
  group_description: "demo security group"
)
```

The convert command is useful for snippets of code.

{% include prev_next.md %}
