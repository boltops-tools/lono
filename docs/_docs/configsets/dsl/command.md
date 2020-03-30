---
title: command
nav_text: DSL
desc: You can use the commands key to execute commands on the EC2 instance. The command
  method maps to the AWS::CloudFormation::Init [commands](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html#aws-resource-init-commands)
  section.
categories: configsets-dsl
order: 6
nav_order: 65
---

{{ page.desc }}

## Example

```ruby
command("create-file",
  command: "touch /tmp/test.txt",
  test: "test -e /tmp/test.txt",
)
command("uptime-command",
  command: "uptime"
)
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    commands:
      001_create-file:
        command: touch /tmp/test.txt
        test: test -e /tmp/test.txt
      002_uptime-command:
        command: uptime
```

## Command Conveniences

Notice above, lono prepends a padded number in front of the command key as a convenience. This is done so commands are processed in the order you declare them. Lono decorates the command method with other conveniences.

### if clause

```ruby
command("create-file",
  command: "touch /tmp/test.txt",
  if: "[ -e /tmp/test.txt ]",
)
```

Generates:

```ruby
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    commands:
      001_create-file:
        command: touch /tmp/test.txt
        test: if [ -e /tmp/test.txt ] ; then true ; else false ; fi
```

### unless clause

```ruby
command("install-jq",
  command: "yum install jq",
  unless: "type jq",
)
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    commands:
      001_install-jq:
        command: yum install jq
        test: if type jq ; then false ; else true ; fi
```

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
