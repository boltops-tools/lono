---
title: lono cfn create STACK
---

## Usage

    lono cfn create STACK

## Summary

create a CloudFormation stack
## Description

Examples:

Provided that you are in a lono project and have a `my-stack` lono template definition.  To create a stack you can simply run:

    lono cfn create my-stack

The above command will generate and use the template in output/my-stack.json and parameters in params/my-stack.txt.  The template by convention defaults to the name of the stack.  In turn, the params by convention defaults to the name of the template.

Here are examples of overriding the template and params name conventions.

    lono cfn create my-stack --template different1

The template used is output/different1.json and the parameters used is output/params/prod/different1.json.

    lono cfn create my-stack --params different2

The template used is output/my-stack.json and the parameters used is output/params/prod/different2.json.

    lono cfn create my-stack --template different3 --params different4

The template used is output/different3.json and the parameters used is output/params/prod/different4.json.


## Options

```
[--randomize-stack-name], [--no-randomize-stack-name]  # tack on random string at the end of the stack name
[--verbose], [--no-verbose]                            
[--noop], [--no-noop]                                  
[--region=REGION]                                      # AWS region
[--template=TEMPLATE]                                  # override convention and specify the template file to use
[--param=PARAM]                                        # override convention and specify the param file to use
[--lono], [--no-lono]                                  # invoke lono to generate CloudFormation templates
                                                       # Default: true
[--capabilities=one two three]                         # iam capabilities. Ex: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--iam], [--no-iam]                                    # Shortcut for common IAM capabilities: CAPABILITY_IAM, CAPABILITY_NAMED_IAM
[--rollback], [--no-rollback]                          # rollback
                                                       # Default: true
```

