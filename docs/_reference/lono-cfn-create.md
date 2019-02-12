---
title: lono cfn create
reference: true
---

## Usage

    lono cfn create STACK

## Description

Create a CloudFormation stack using the generated template.

## Examples

Provided that you are in a lono project and have a `demo` lono blueprint that contains a `demo` template.  To create a stack you can run:

    lono cfn create demo

The above command will generate:

* template:   output/demo/templates/demo.yml
* parameters: output/demo/params/development.json

By [convention]({% link _docs/conventions/cli.md %}), the blueprint name is the same as the stack name. In turn, template name is the same as the blueprint name. Lastly, the param name will default to the template name.

Here are examples of overriding the template and params name conventions.

    lono cfn create demo --template different1

The template used is `app/templates/different1.rb` and the parameters used is `configs/demo/params/development/demo/different1.txt`.

    lono cfn create demo --param different2

The template used is `app/templates/demo.rb` and the parameters used is `configs/demo/params/development/demo/different2.json`.

    lono cfn create demo --template different3 --param different4

The template used is `app/templates/different3.rb` and the parameters used is `configs/demo/params/different3/different4.json`.


## Options

```
[--blueprint=BLUEPRINT]         # override convention and specify the template file to use
[--template=TEMPLATE]           # override convention and specify the template file to use
[--param=PARAM]                 # override convention and specify the param file to use
[--lono], [--no-lono]           # invoke lono to generate CloudFormation templates
                                # Default: true
[--capabilities=one two three]  # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--iam], [--no-iam]             # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--rollback], [--no-rollback]   # rollback
                                # Default: true
[--tags=key:value]              # Tags for the stack. IE: name:api-web owner:bob
[--suffix=SUFFIX]               # Suffix for stack name.
[--wait], [--no-wait]           # Wait for stack operation to complete.
                                # Default: true
[--verbose], [--no-verbose]     
[--noop], [--no-noop]           
```

