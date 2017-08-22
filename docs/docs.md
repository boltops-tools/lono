---
title: Docs
---

### Overview

Lono is a framework tool to help you easily manage your CloudFormation templates.  Lono handles the entire CloudFormation lifecyle. It starts with helping you craft of the templates and helps you all the way to end when you provision of the infrastructure.

{:.overview-stages}
1. The first stage of lono is you crafting and writing the CloudFormation templates. Lono enables you to write your CloudFormation templates in an ERB templating language and provides useful helper methods. Once you are ready then you generate the templates with `lono generate`.
2. You then specify the desired parameters that you want the CloudFormation template to launch with. You do this with simple env-like params files. The format is easy on the eyes.
3. Lono puts it all together and in the end and launches the stack for you! It takes what is normally a complicated multiple step process and simplifies it down to a single command: `lono cfn create`.

Here is a diagram of how lono works.

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

* Lono generates standard CloudFormation from ERB templates, providing you with all the power of ERB's templating engine.
* Lono allows you to write your CloudFormation parameters files in a simple env-like file.
* Lono provides a simple command line interface to create, update, delete and preview CloudFormation

Next we'll cover different ways to install lono.

<a id="prev" class="btn btn-basic" href="{% link quick-start.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/install.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

