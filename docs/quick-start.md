---
title: Quick Start
---

In a hurry? No problem!  Here's a quick start to using lono that takes only a few minutes.  The commands below launches a CloudFormation stack.

{% highlight bash %}
brew cask install boltopslabs/software/bolts
lono new infra
cd infra
lono cfn create example
{% endhighlight %}

Check out the newly launch stack in the AWS console:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

Congratulations!  You have successfully created a CloudFormation stack with lono. It's that simple. 😁

### The lono cfn command

Lono provides `lono cfn` lifecycle management commands that allow you to launch stacks using the generated lono templates. The `lono cfn` commands automatically runs `lono generate` internally before launching the CloudFormation stack.  This enables you to do everything in a single command. Provided that you are in a lono project and have a `mystack` lono template definition. To create the stack you simply run::

```
$ lono cfn create mystack
```

The above command will generate files to `output/mystack.json` and `output/params/prod/mystack.txt` and use them to create a CloudFormation stack. Here are some more examples of cfn commands::

```
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) --template mystack --params mystack
$ lono cfn create mystack # shorthand if template and params file matches.
$ lono cfn diff mystack
$ lono cfn preview mystack
$ lono cfn update mystack
$ lono cfn delete mystack
$ lono cfn create -h # getting help
```

<a id="next" class="btn btn-primary" href="{% link docs.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

