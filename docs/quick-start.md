---
title: Quick Start
---

In a hurry? No problem!  Here's a quick start to using lono that takes only a few minutes.  The commands below launches a CloudFormation stack.  It's that simple.

{% highlight bash %}
brew cask install boltopslabs/software/bolts
lono new infra
cd infra
lono cfn create example
{% endhighlight %}

Check out the newly launch stack in the AWS console:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

Congratulations!  You have successfully created a CloudFormation stack with lono. It was really that simple 😁

### lono cfn summary

Lono provides a `lono cfn` management command that allows you to launch stacks from the generated lono templates. The `lono cfn` tool automatically runs `lono generate` internally and then launches the CloudFormation stack in a single command. Provided that you are in a lono project and have a `my-stack` lono template definition. To create a stack you can simply run::

```
$ lono cfn create my-stack
```

The above command will generate files to `output/prod/my-stack.json` and `output/params/prod/my-stack.txt` and use them to create a CloudFormation stack. Here are some more examples of cfn commands::

```
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) --template mystack --params mystack
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) # shorthand if template and params file matches.
$ lono cfn diff mystack-1493859659
$ lono cfn preview mystack-1493859659
$ lono cfn update mystack-1493859659
$ lono cfn delete mystack-1493859659
$ lono cfn create -h # getting help
```

<a id="next" class="btn btn-primary" href="{% link docs.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

