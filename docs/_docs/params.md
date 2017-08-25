---
title: Params
---

Lono provides a way to specify your runtime CloudFormation launch parameters in a simple `key=value` format commonly found in env files.  This format is less prone to human error than the AWS verbose parameter file format.  When `lono generate` is ran it processes the files in `params` folders and outputs the AWS JSON format file in `output/params` folder.  Here's an example:

`params/base/example.txt`:

```sh
KeyName=tutorial
InstanceType=t2.micro
```

This results in:

```json
[
  {
    "ParameterKey": "InstanceType",
    "ParameterValue": "t2.micro"
  },
  {
    "ParameterKey": "KeyName",
    "ParameterValue": "tutorial"
  }
]
```

These files can be used to launch the CloudFormation stack with the `aws cloudformation` CLI tool manually if you like. Though the `lono cfn` lifecycle commands handle this automatically for you. For example, running `lono cfn create [STACK_NAME]` will automatically generate the param files and use it when launching the stack.

Lono param files also support layering which is covered in [Layering Support]({% link _docs/layering.md %}).

<a id="prev" class="btn btn-basic" href="{% link _docs/config-variables.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/layering.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
