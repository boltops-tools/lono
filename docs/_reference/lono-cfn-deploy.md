---
title: lono cfn deploy
reference: true
---

## Usage

    lono cfn deploy STACK

## Description

Create or update a CloudFormation stack using the generated template.

The `cfn deploy` command figures out whether or not it should perform a stack create or update. It delegates to `cfn create` or `cfn update`.  This saves you from thinking about it

# Examples

Provided that you are in a lono project and have a `demo` lono blueprint that contains a `demo` template.  To create a stack you can run:

    lono cfn deploy demo

The above command will generate:

* template:   output/demo/templates/demo.yml
* parameters: output/demo/params/development.json

By [convention]({% link _docs/conventions/cli.md %}), the blueprint name is the same as the stack name. In turn, template name is the same as the blueprint name. Lastly, the param name will default to the template name.  Some examples follow to help explain.

## Convention: Stack, Blueprint, Template and Parameter are All the Same

Let's say you have a blueprint in `blueprints/demo` with a structure the looks something like this:

    .
    ├── blueprints
    │   └── demo
    │       └── app
    │           └── templates
    │               ├── demo.rb
    │               └── ec2.rb
    └── configs
        └── demo
            └── params
                ├── base.txt
                └── development.txt

The command:

    lono cfn deploy demo

Will use:

* blueprint: blueprints/demo
* template: blueprints/demo/app/templates/demo.rb
* param: configs/demo/params/development.txt

## Stack and Blueprint Do Not Match But Everything Else Does

This is a common case, where the stack name is different from the blueprint name.

    lono cfn deploy my-demo --blueprint demo

The stack will be called my-demo and the blueprint is `demo`.  Since by convention, templates default to the blueprint name we're pretty much set.  Lono will use:

* blueprint: blueprints/demo
* template: blueprints/demo/app/templates/demo.rb
* param: configs/demo/params/development.txt

Everything is the same as when the stack name matches the blueprint name.

## Blueprint and Template Name Do Not Match, But Template and Param Name Matches

    lono cfn deploy my-demo --blueprint demo --template ec2

In this case we are using the ec2 template within the demo blueprint.  We'll add another param file `configs/demo/params/ec2.txt`

    └── configs
        └── demo
            └── params
                └── ec2.txt

Lono will use these files:

* blueprint: blueprints/demo
* template: blueprints/demo/app/templates/ec2.rb
* param: configs/demo/params/ec2.txt

## Template Name and Param Name Do Not Match

The form with most control is the one with all options explicitly specified.

    lono cfn deploy my-demo --blueprint demo --template ec2 --param large

We'll add another parameter file here: `configs/demo/params/ec2/large.txt`

    └── configs
        └── demo
            └── params
                └── ec2
                    └── large.txt

Lono will use these files:

* blueprint: blueprints/demo
* template: blueprints/demo/app/templates/ec2.rb
* param: configs/demo/params/ec2/large.txt


## Options

```
[--blueprint=BLUEPRINT]                          # override convention and specify the template file to use
[--template=TEMPLATE]                            # override convention and specify the template file to use
[--param=PARAM]                                  # override convention and specify the param file to use
[--lono], [--no-lono]                            # invoke lono to generate CloudFormation templates
                                                 # Default: true
[--capabilities=one two three]                   # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--iam], [--no-iam]                              # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--rollback], [--no-rollback]                    # rollback
                                                 # Default: true
[--tags=key:value]                               # Tags for the stack. IE: name:api-web owner:bob
[--suffix=SUFFIX]                                # Suffix for stack name.
[--change-set], [--no-change-set]                # Uses generated change set to update the stack.  If false, will perform normal update-stack.
                                                 # Default: true
[--codediff-preview], [--no-codediff-preview]    # Show codediff changes preview.
                                                 # Default: true
[--changeset-preview], [--no-changeset-preview]  # Show ChangeSet changes preview.
                                                 # Default: true
[--param-preview], [--no-param-preview]          # Show parameter diff preview.
                                                 # Default: true
[--sure], [--no-sure]                            # Skips are you sure prompt
[--wait], [--no-wait]                            # Wait for stack operation to complete.
                                                 # Default: true
[--verbose], [--no-verbose]                      
[--noop], [--no-noop]                            
```

