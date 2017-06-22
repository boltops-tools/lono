---
title: Create the Stack
---

We are now ready to create the stack.  Let's launch it!

```sh
lono cfn create example --template single_instance
```

You should see similiar output.

```sh
$ lono cfn create example --template single_instance
Using template: output/single_instance.yml
Using parameters: params/single_instance.txt
Generating CloudFormation templates:
  output/single_instance.yml
  output/instance_and_route53.yml
Params file generated for example at output/params/example.json
Creating example stack.
$
```

In the previous steps we ran `lono generate` manually to demonstrate how lono generates CloudFormation template and parameter files.  Notice that `lono cfn create` also automatically generates calls `lono generate` and generates the template and parameter files for you!

You can check on the status of the stack creation with the AWS Console.  It should look similar to this:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

Congratulations!  You have successfully created a CloudFormation stack with lono.

### lono cfn create

Let's review the `lono cfn create` command in a little more detail.

Long form:

```
$ lono cfn create my-stack --template my-stack --params --my-stack
```

Short form:

```
$ lono cfn create my-stack
```

Both template and params conventions can be overridden.  Here are examples of overriding the template and params name conventions.

```
$ lono cfn create my-stack --template different-name1
```

The template that will be use is output/different-name1.json and the parameters will use params/different-name1.json.

```
$ lono cfn create my-stack --params different-name2
```

The template that will be use is output/different-name2.json and the parameters will use params/different-name2.json.

```
$ lono cfn create my-stack --template different-name3 --params different-name4
```

The template that will be use is output/different-name3.json and the parameters will use params/different-name4.json.

In the next steps you'll see that lono has some useful commands to help you update the templates.

<a id="prev" class="btn btn-basic" href="{% link _docs/scratch-params-build.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/scratch-cfn-update.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

