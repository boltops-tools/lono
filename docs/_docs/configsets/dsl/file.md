---
title: file
nav_text: DSL
desc: You can use the files key to create files on the EC2 instance. The content can
  be either inline in the template or the content can be pulled from a URL. The file
  method maps to the AWS::CloudFormation::Init [files](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html#aws-resource-init-files)
  section.
categories: configsets-dsl
order: 5
nav_order: 64
---

{{ page.desc }}

## Example

```ruby
file("/tmp/myfile1.txt",
  content: "/tmp/myfile1.txt",
  mode: "120644",
)
file("/tmp/myfile2.txt",
  content: "/tmp/myfile2.txt",
  mode: "120644",
)
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    files:
      "/tmp/myfile1.txt":
        content: "/tmp/myfile1.txt"
        mode: '120644'
      "/tmp/myfile2.txt":
        content: "/tmp/myfile2.txt"
        mode: '120644'
```

Tip: The [content_file]({% link _docs/configsets/helpers/built-in/content_file.md %}) helper, can be use to clean up the code and move content to other files.

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
