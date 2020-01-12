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
    [--rollback], [--no-rollback]   # rollback
                                    # Default: true
    [--source=SOURCE]               # url or path to file with template
    [--blueprint=BLUEPRINT]         # override convention and specify the template file to use
    [--capabilities=one two three]  # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
c, [--config=CONFIG]                # override convention and specify both the param and variable file to use
    [--iam], [--no-iam]             # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
p, [--param=PARAM]                  # override convention and specify the param file to use
    [--tags=key:value]              # Tags for the stack. IE: Name:api-web Owner:bob
    [--template=TEMPLATE]           # override convention and specify the template file to use
v, [--variable=VARIABLE]            # override convention and specify the variable file to use
    [--wait], [--no-wait]           # Wait for stack operation to complete.
                                    # Default: true
    [--sure], [--no-sure]           # Skip are you sure prompt
    [--verbose], [--no-verbose]     
    [--noop], [--no-noop]           
```

