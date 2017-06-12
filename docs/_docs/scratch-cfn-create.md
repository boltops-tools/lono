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

Congratulations!  You have successfully created a CloudFormation stack with lono.  In the next steps you'll see that lono has some useful commands to help you update the templates.

<a id="prev" class="btn btn-basic" href="{% link _docs/scratch-params-build.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/scratch-cfn-update.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

