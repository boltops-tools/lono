---
title: Lono Code Convert
nav_order: 8
---

<div class="video-box"><div class="video-container"><iframe src="https://www.youtube.com/embed/uC-TcZKqsf4" frameborder="0" allowfullscreen=""></iframe></div></div>

{% include lono-code-excerpt.md %}

The [lono code convert](https://lono.cloud/reference/lono-code-convert/) command allows you to take JSON or YAML templates and convert it to the Lono Ruby DSL code. The conversion process saves you engineering time writing it yourself.

## Usage: lono code convert

The [lono code convert](https://lono.cloud/reference/lono-code-convert/) commmand will convert snippets of template code to Ruby code. Here's an example:

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

The INFO messages are written to stderr and the Ruby code output is written to stdout. We're using bash redirection write to `template.rb`. Here's what `template.rb` looks like

```ruby
resource("Instance", "AWS::EC2::Instance",
  InstanceType: ref("InstanceType"),
  ImageId: find_in_map("AmiMap",ref("AWS::Region"),"Ami"),
  SecurityGroupIds: [
    get_att("SecurityGroup.GroupId")
  ],
  UserData: base64("#!/bin/bash\necho \"hello world\"")
)
resource("SecurityGroup", "AWS::EC2::SecurityGroup",
  GroupDescription: "demo security group"
)
```

The convert command saves a ton of time.

{% include prev_next.md %}
