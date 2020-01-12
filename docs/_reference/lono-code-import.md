---
title: lono code import
reference: true
---

## Usage

    lono code import SOURCE

## Description

Imports CloudFormation template and converts it to Ruby code.

## Examples

    lono code import path/to/file
    lono code import http://example.com/url/to/template.yml
    lono code import http://example.com/url/to/template.json
    lono code import http://example.com/url/to/template.json --blueprint myblueprint

## Example with Output

    $ URL=https://s3.amazonaws.com/cloudformation-templates-us-east-1/EC2InstanceWithSecurityGroupSample.template
    $ lono code import $URL --blueprint ec2
    => Creating new blueprint called ec2.
          create  blueprints/ec2
          create  blueprints/ec2/ec2.gemspec
          create  blueprints/ec2/.gitignore
          create  blueprints/ec2/.meta/config.yml
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


## Options

```
[--blueprint=BLUEPRINT]                        # final blueprint name
[--casing=CASING]                              # Controls casing of logical ids. IE: as-is, camelcase or underscore
                                               # Default: as-is
[--summary], [--no-summary]                    # provide template summary after import
                                               # Default: true
[--template=TEMPLATE]                          # final template name of downloaded template without extension
[--template-name-casing=TEMPLATE_NAME_CASING]  # camelcase or dasherize the template name
                                               # Default: dasherize
[--type=TYPE]                                  # import as a DSL or ERB template
                                               # Default: dsl
```

