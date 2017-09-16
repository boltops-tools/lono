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

### Template name: CamelCase or dasherize

You can specify whether or not to CamelCase or dasherize the name of the final template file with the `--casing` option.  Examples:

Underscore:

```sh
lono import https://s3.amazonaws.com/cloudformation-templates-us-east-1/EC2InstanceWithSecurityGroupSample.template --casing dasherize
```

CamelCase:

```sh
lono import https://s3.amazonaws.com/cloudformation-templates-us-east-1/EC2InstanceWithSecurityGroupSample.template --casing camelcase
```

The default is dasherize.

Question: You might be wondering, why does lono import has dasherize vs underscore?

Answer: I prefer filenames to be underscore. However, CloudFormation stack names do not allow underscores in their naming, so it is encourage to either dasherize or camelize your template names so the stack name and the template name can be the same.

<a id="prev" class="btn btn-basic" href="{% link _docs/lono-env.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/config-templates.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
