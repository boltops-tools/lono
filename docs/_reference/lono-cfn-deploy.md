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


## Conventions

By [convention]({% link _docs/conventions/cli.md %}), the blueprint name is the same as the stack name. In turn, template name is the same as the blueprint name. Lastly, the param name will match the stack name unless it's explicitly specified with `--config` or `--param`.

Often you want to create a stack name that is different from the blueprint name. Here’s an example of overriding the blueprint name.

    lono cfn deploy my-stack --blueprint demo


## Options

```
    [--rollback], [--no-rollback]                    # rollback
                                                     # Default: true
    [--source=SOURCE]                                # url or path to file with template
    [--blueprint=BLUEPRINT]                          # override convention and specify the template file to use
    [--capabilities=one two three]                   # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
c, [--config=CONFIG]                                 # override convention and specify both the param and variable file to use
    [--iam], [--no-iam]                              # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
p, [--param=PARAM]                                   # override convention and specify the param file to use
    [--tags=key:value]                               # Tags for the stack. IE: Name:api-web Owner:bob
    [--template=TEMPLATE]                            # override convention and specify the template file to use
v, [--variable=VARIABLE]                             # override convention and specify the variable file to use
    [--change-set], [--no-change-set]                # Uses generated change set to update the stack.  If false, will perform normal update-stack.
                                                     # Default: true
    [--changeset-preview], [--no-changeset-preview]  # Show ChangeSet changes preview.
                                                     # Default: true
    [--codediff-preview], [--no-codediff-preview]    # Show codediff changes preview.
                                                     # Default: true
    [--param-preview], [--no-param-preview]          # Show parameter diff preview.
                                                     # Default: true
    [--wait], [--no-wait]                            # Wait for stack operation to complete.
                                                     # Default: true
    [--sure], [--no-sure]                            # Skip are you sure prompt
    [--verbose], [--no-verbose]                      
    [--noop], [--no-noop]                            
```

