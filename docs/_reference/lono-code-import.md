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

## Example with Output

    $ URL=https://s3-us-east-2.amazonaws.com/cloudformation-templates-us-east-2/AutoScalingMultiAZWithNotifications.template
    $ lono code import $URL --blueprint asg
    Template imported to: blueprints/asg/app/templates/asg.rb
    Params file created at configs/asg/development.txt
    $

## Lono Pro

This is a lono-pro addon command.


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

