---
title: Quick Start
---

In a hurry? No problem!  Here's a quick start to using lono that takes only a few minutes.  The commands below launches a CloudFormation stack.  It's that simple.

{% highlight bash %}
brew tap boltopslabs/boltops
brew cask install bolts
lono new infra
cd infra
lono cfn create example
{% endhighlight %}

Check out the newly launch stack in the AWS console:

<img src="/img/tutorial/stack-created.png" alt="Stack Created" class="doc-photo">

Congratulations!  You have successfully created a CloudFormation stack with lono. It was really simple 😁

<a class="btn btn-primary" href="{% link _docs/install.md %}">Next Step</a>
