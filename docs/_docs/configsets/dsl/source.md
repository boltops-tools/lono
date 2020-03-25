---
title: source
nav_text: DSL
desc: You can use the sources key to download an archive file and unpack it in a target
  directory on the EC2 instance. This key is fully supported for both Linux and Windows
  systems. The source method maps to the AWS::CloudFormation::Init [sources](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html#aws-resource-init-sources)
  section.
categories: configsets-dsl
order: 4
nav_order: 63
---

{{ page.desc }}

## Example

```ruby
source("/opt/cfn-demo" => "https://github.com/user1/cfn-demo/tarball/master")
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    sources:
      "/opt/cfn-demo": https://github.com/user1/cfn-demo/tarball/master
```

## Private S3 Source

Private S3 sources require a [AWS::CloudFormation::Authentication](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-authentication.html) resource. Lono can dynamically add the resource with the `authentication` method. Example:

```ruby
authentication "IamRole" # adjust to match IamRole in template
source("/opt/mygem" => s3_key("mygem")) # uses lib/files/mygem folder
```

The `s3_key("mygem")` corresponds to the `lib/files/mygem` folder within the configset. For example:

    app/configsets/myconfigset/lib/files/mygem

The code uses this info to generate:

```yaml
---
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    sources:
      "/opt/mygem": https://lono-bucket-12di8xz5sy72z.s3-us-west-2.amazonaws.com/development/output/BLUEPRINT/configsets/mygem/files/mygem-file-a328be46.zip
AWS::CloudFormation::Authentication:
  rolebased:
    type: S3
    buckets:
    - lono-bucket-12di8xz5sy72z
    roleName:
      Ref: IamRole
```

Files in the the configset `lib/files/mygem` directory are zipped and uploaded to S3 as part of the [lono cfn deploy]({% link _reference/lono-cfn-deploy.md %}) process. It's s3 location is then reference in the template. This spares you from having to upload files manually and updating the template.

### authentication as variable

The authentication IAM role can also be set as variable:

configs/BLUEPRINT/configsets/variables.rb:

```ruby
@authentication = "IamRole"
```

By design, the `@authentication` variable takes higher precedence than the value set by `authentication "IamRole"` method call. This allows more flexilbity to use the configset with templates, as you can use variables to adjust the IAM Role name to match with the template.

### authentication as full structure

The authentication can also accept the full structure of [AWS::CloudFormation::Authentication](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-authentication.html) resource.

configs/BLUEPRINT/configsets/variables.rb:

```ruby
@authentication = {
  rolebased: {
    type: "S3",
    buckets: [lono_bucket_name], # lono_bucket_name - helper returns the lono s3 bucket where files are uploaded
    roleName: ref("IamRole"),
  }
}
```

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
