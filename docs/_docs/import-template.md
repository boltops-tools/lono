---
title: Import Template
---

Lono provides a `lono import` command to spare you from manually having to convert a standard CloudFormation template into a lono-ify CloudFormation template.  Usage:

```sh
lono import path/to/template
lono generate
```

You can also specify urls:

```sh
lono import https://s3.amazonaws.com/solutions-reference/aws-waf-security-automations/latest/aws-waf-security-automations.template
lono generate
```

The command downloads the template to `templates` folder and converts it into yaml and declares a new template definition for you in the `config/templates/base/stacks.rb` file.

You are able to run `lono generate` immediately after the `lono generate` command.

<a id="prev" class="btn btn-basic" href="{% link _docs/docs-start.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/directory-structure.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
