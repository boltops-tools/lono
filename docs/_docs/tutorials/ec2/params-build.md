---
title: Build the Params
---

#### Create the Param Files

With lono, you can specify CloudFormation parameters with simple formatted `key=value` env-like file.  Add the following to your `params/base/single_instance.txt` file.

```sh
KeyName=tutorial
InstanceType=t2.micro
```

NOTE: This example uses a `tutorial` ssh keypair that allows you to log into the instance. You must create the keypair first before you are able to launch the stack.

NOTE: Also you need to create the stack.local HostZoneName first.

#### Generate from params files

You can generate the CloudFormation JSON formatted parameter files with the `lono generate` command again.

```sh
lono generate
```

You should see similar output.

```sh
$ lono generate
Generating both CloudFormation template and parameter files.
Generating CloudFormation templates:
  output/single_instance.yml
  output/instance_and_route53.yml
Generating params files
Params file generated for single_instance at output/params/prod/single_instance.json
$
```

Let's take a look at the `output/params/prod/single_instance.json` file:

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

As you can see, the simple `params/base/single_instance.txt` has been converted to the CloudFormation parameter file format.

<a id="prev" class="btn btn-basic" href="{% link _docs/tutorials/ec2/template-generate.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorials/ec2/cfn-create.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
