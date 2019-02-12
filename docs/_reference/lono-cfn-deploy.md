---
title: lono cfn deploy
reference: true
---

## Usage

    lono cfn deploy STACK

## Description

Create or update a CloudFormation stack using the generated template.

The `cfn deploy` command figures out whether or not it should perform a stack create or update. It delegates to `cfn create` or `cfn update`.  This saves you from thinking about it

## Examples

Provided that you are in a lono project and have a `demo` lono blueprint that contains a `demo` template.  To create a stack you can run:

    lono cfn deploy demo

The above command will generate:

* template:   output/demo/templates/demo.yml
* parameters: output/demo/params/development.json

By [convention]({% link _docs/conventions/cli.md %}), the blueprint name is the same as the stack name. In turn, template name is the same as the blueprint name. Lastly, the param name will default to the template name.

Here are examples of overriding the template and params name conventions.

    lono cfn deploy demo --template different1

The template used is `app/templates/different1.rb` and the parameters used is `configs/demo/params/development/demo/different1.txt`.

    lono cfn deploy demo --param different2

The template used is `app/templates/demo.rb` and the parameters used is `configs/demo/params/development/demo/different2.json`.

    lono cfn deploy demo --template different3 --param different4

The template used is `app/templates/different3.rb` and the parameters used is `configs/demo/params/different3/different4.json`.


## Options

```
[--blueprint=BLUEPRINT]            # override convention and specify the template file to use
[--template=TEMPLATE]              # override convention and specify the template file to use
[--param=PARAM]                    # override convention and specify the param file to use
[--lono], [--no-lono]              # invoke lono to generate CloudFormation templates
                                   # Default: true
[--capabilities=one two three]     # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--iam], [--no-iam]                # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--rollback], [--no-rollback]      # rollback
                                   # Default: true
[--tags=key:value]                 # Tags for the stack. IE: name:api-web owner:bob
[--suffix=SUFFIX]                  # Suffix for stack name.
[--change-set], [--no-change-set]  # Uses generated change set to update the stack.  If false, will perform normal update-stack.
                                   # Default: true
[--diff], [--no-diff]              # Show diff of the source code template changes before continuing.
                                   # Default: true
[--preview], [--no-preview]        # Show preview of the stack changes before continuing.
                                   # Default: true
[--sure], [--no-sure]              # Skips are you sure prompt
[--wait], [--no-wait]              # Wait for stack operation to complete.
                                   # Default: true
[--verbose], [--no-verbose]
[--noop], [--no-noop]
```
