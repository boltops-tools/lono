---
title: Directory Structure
---

A basic lono project usually looks something like this:

```sh
.
├── config
│   ├── lono
│   │   └── api.rb
│   └── lono.rb
├── params
│   └── api-web-prod.txt
├── output
└── templates
    ├── db.yml.erb
    ├── partial
    │   ├── host_record.yml.erb
    │   ├── server.yml.erb
    │   └── user_data
    │       └── bootstrap.sh.erb
    └── web.yml.erb
```

#### An overview of folders

File / Directory  | Description
------------- | -------------
<code>config/</code>  | Configure your lono templates and variables here.  This is where you specify what templates to generate to the output folder. The template blocks are covered in more detail in [template configuration](/template-configuration).
<code>params/</code>  | Specific your parameters for the CloudFormation stacks to be launched.
<code>output/</code>  | The place where the CloudFormation templates and parameter files are generated to.  These files can be use with the raw `aws cloudformation` commands.
<code>templates/</code>  | The ERB templates with the "view" code.  The template are covered in more detail in [template helpers](/template-helpers).

Now that you have a basic feel for the lono directory structure, let's create a lono project.

<a id="prev" class="btn btn-basic" href="{% link _docs/install.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

