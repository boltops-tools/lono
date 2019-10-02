---
title: Params
order: 3
nav_order: 11
---

Params are configs that you define to affect how the templates behave at runtime when the CloudFormation stack is launched.  Lono provides a way to specify the parameters in a simple `key=value` format commonly found in env files.  This format is less prone to human error than the AWS verbose parameter file format.  When `lono generate` is ran it processes the files in `configs/BLUEPRINT/params` folders and outputs the AWS JSON format file in `output/BLUEPRINT/params` folder.  Here's an example:

configs/demo/params/development.txt:

    KeyName=default
    InstanceType=t2.micro

This results in:

```json
[
  {
    "ParameterKey": "InstanceType",
    "ParameterValue": "t2.micro"
  },
  {
    "ParameterKey": "KeyName",
    "ParameterValue": "default"
  }
]
```

These files can be used to launch the CloudFormation stack with the `aws cloudformation` CLI tool manually if you like. Though the `lono cfn` lifecycle commands handle this automatically for you. For example, running `lono cfn deploy STACK_NAME` will automatically generate the param files and use it when launching the stack.

## Shared Variables Substitution

Shared variables substitution is supported in params file.  Here's an example:

configs/demo/variables/base.rb:

    @ami = "ami-12345"

configs/demo/params/base.txt:

    Ami=<%= @ami %>

Will produce:

output/demo/params/mystack.json:

```json
[
  {
    "ParameterKey": "Ami",
    "ParameterValue": "ami-12345"
  }
]
```

## Layering Support

Lono param files also support layering which is covered in [Layering Support]({% link _docs/core/layering.md %}).

## Params Files Lookup Locations

What we are setting above with the `--param` option is the param "name". The param name is used to look up different possible param locations. This is covered in more details here: [Params Lookup Locations]({% link _docs/lookup-locations/params.md %}).

{% include prev_next.md %}