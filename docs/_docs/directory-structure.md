---
title: Directory Structure
---

A basic lono project usually looks something like this:

```sh
.
├── config
│   ├── templates
│   │   ├── base
│   │   │   ├── blog.rb
│   │   │   └── stacks.rb
│   │   ├── prod
│   │   │   └── stacks.rb
│   │   └── stag
│   │       └── stacks.rb
│   └── variables
│       ├── base
│       │   └── variables.rb
│       ├── prod
│       │   └── variables.rb
│       └── stag
│           └── variables.rb
├── helpers
│   └── my_custom_helper.rb
├── output
├── params
│   ├── base
│   │   ├── api-web-prod.txt
│   │   └── example.txt
│   ├── prod
│   │   └── example.txt
│   └── stag
│       └── example.txt
└── templates
    ├── db.yml
    ├── example.yml
    ├── partial
    │   ├── host_record.yml
    │   ├── server.yml
    │   └── user_data
    │       └── bootstrap.sh
    └── web.yml
```

#### An overview of folders

File / Directory  | Description
------------- | -------------
`config/templates`  | Configure your lono templates and template specific variables here.  This is where you specify what templates to generate to the output folder. The templates are automatically layered together based on `LONO_ENV`.  The template blocks are covered in more detail in [templates configuration]({% link _docs/config-templates.md %}).
`config/variables`  | Configure your global lono variables here.  This is where you specify global variables that are available globally in the all template blocks and all the template views. The variables are automatically layered together based on `LONO_ENV`. The variables are covered in more detail in [variables configuration]({% link _docs/config-variables.md %}).
`helpers`  | Define your custom helpers here. The custom helpers are made avaiable to lono config template blocks and template views.  Helpers are covered in more detail in [custom helpers]({% link _docs/custom-helpers.md %}).
`params`  | Specific your parameters for the CloudFormation stacks to be launched. The params are automatically layered together based on `LONO_ENV`.  The params are covered in more detail in [params]({% link _docs/params.md %}).
`output`  | This is where the generated CloudFormation templates and parameter files are written to.  These files can be use with the raw `aws cloudformation` commands.
`templates`  | The ERB templates with the "view" code.  The template are covered in more detail in [template helpers](/template-helpers).

Now that you have a basic feel for the lono directory structure, let's create a lono project.

<a id="prev" class="btn btn-basic" href="{% link _docs/install.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
