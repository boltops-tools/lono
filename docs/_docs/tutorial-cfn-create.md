---
title: Create the Stack
---

We are now ready to create the stack.  Let's launch it!

```sh
lono cfn create example --template single_instance
```

You should see this similar output.

```sh
$ lono cfn create example --template single_instance
Using template: output/single_instance.yml
Using parameters: params/prod/single_instance.txt
Generating CloudFormation templates:
  output/single_instance.yml
  output/instance_and_route53.yml
Params file generated for example at output/params/prod/example.json
Creating example stack.
$
```

In the previous steps, we ran `lono generate` manually to demonstrate how lono generates CloudFormation templates and parameter files.  Notice that `lono cfn create` also automatically generates calls `lono generate` and generates the template and parameter files for you!

You can check on the status of the stack creation with the AWS Console.  It should look similar to this:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

Congratulations!  You have successfully created a CloudFormation stack with lono.

### lono cfn create

Let's review the `lono cfn create` command in a little more detail.

Long form:

```
$ lono cfn create mystack --template mystack --params --mystack
```

Short form:

```
$ lono cfn create mystack
```

Both template and params conventions can be overridden.  Here are examples of overriding the template and params name conventions.

```
$ lono cfn create mystack --template different1
```

The template that will be use is `output/different1.json` and the parameters will use `output/params/prod/different1.json`.

```
$ lono cfn create mystack --params different2
```

The template that will be use is `output/different2.json` and the parameters will use `output/params/prod/different2.json`.

```
$ lono cfn create mystack --template different3 --params different4
```

The template that will be used is `output/different3.json` and the parameters will use `output/params/prod/different4.json`.

In the next steps, you will learn about some useful commands lono provides to help you update the templates.

<a id="prev" class="btn btn-basic" href="{% link _docs/tutorial-params-build.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial-cfn-update.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

