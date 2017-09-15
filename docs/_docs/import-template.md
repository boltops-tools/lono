---
title: Import Template
---

Lono provides a `lono import` command to spare you from manually having to convert a standard CloudFormation template into a lono CloudFormation template.  Usage:

```sh
lono import https://s3.amazonaws.com/cloudformation-templates-us-east-1/EC2InstanceWithSecurityGroupSample.template
lono generate
```

You can also specify standard file paths:

```sh
lono import path/to/template
lono generate
```

The command downloads the template to `templates` folder, converts it into YAML, and declares a new template definition in `config/templates/base/stacks.rb`.

You can run `lono generate` immediately after the `lono import` command.

<a id="prev" class="btn btn-basic" href="{% link _docs/lono-env.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/config-templates.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
