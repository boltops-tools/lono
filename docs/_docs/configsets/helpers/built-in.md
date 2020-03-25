---
title: Configset Built-In Helpers
nav_text: Built-In Helpers
categories: configsets
order: 6
nav_order: 70
---

Lono provides additional built-in helpers with the configset DSL.

Name | Description
--- | ---
authentication | The authentication is use with the [source]({% link _docs/configsets/dsl/source.md %}) method to add [AWS::CloudFormation::Authentication](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-authentication.html). This allows you to download files from  private sources.
[content_file]({% link _docs/configsets/helpers/built-in/content_file.md %}) | renders a file in the `lib/content` folder of the configset.
gem_package | This installs a gem.
s3_key | Used with the [source]({% link _docs/configsets/dsl/source.md %}) method to reference configset `lib/files` that were automatically uploaded to s3.
yum_package | Install a yum package.

The built-in helpers are defined here in the lono source: [configset/strategy/helpers](https://github.com/tongueroo/lono/tree/master/lib/lono/configset/strategy/helpers)

{% include prev_next.md %}
