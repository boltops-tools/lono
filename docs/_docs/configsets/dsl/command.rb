---
title: Command
---

The `command` method maps to the [AWS::CloudFormation::Init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html) commands section.

## Example

```ruby
command("create-file",
  command: "touch /tmp/test.txt",
  test: "test -e /tmp/test.txt",
)
```

Ultimately, the `command` method creates a YAML structure that can be natively processed by cfn-init.

```yaml
commands:
  create-file:
    command: "touch /tmp/test.txt"
    test: "test -e /tmp/test.txt"
```

## Additional Conveniences

Lono configset methods adds some nice conveniences on top of the simple YAML structure.

### if condition

```ruby
command("add-to-file",
  command: "echo 'foo=bar' >> /tmp/test.txt",
  if: "grep foo=bar",
)
```

The `if` property is a convenience wrapper that translate to a `test` property. It maps down to:

```yaml
commands:
  create-file:
    command: "echo 'foo=bar' >> /tmp/test.txt"
    test: "if grep foo=bar ; then false ; else true ; fi"
```

{% include prev_next.md %}
