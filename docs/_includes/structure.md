#### Folders Overview

File / Directory  | Description
------------- | -------------
app/definitions | Here's where you define or declare your template definitions. It tells lono what templates to generate to the `output` folder.  You can specify the template output name and the source template to use here. The templates are [automatically layered together]({% link _docs/layering.md %}) based on `LONO_ENV`.  The template blocks are covered in more detail in [templates configuration]({% link _docs/app-definitions.md %}).
app/helpers | Define your custom helpers here. The custom helpers are made available to `app/definitions`, `app/templates`, and `config/parameters`. Helpers are covered in more detail in custom helpers.
app/partials | Where templates partials go. You can split up the CloudFormation templates into erb partials. Include them with the `partial` helper.
app/scripts | Where your custom scripts go. Scripts in this folder get uploaded to s3 as a tarball during the `cfn create` or `update` command.
app/user_data | Where you place your scripts meant to be use for user-data. Include them into your templates with the `user_data` helper method.
config/params | Where you specific your run-time parameters for the CloudFormation stacks. Params files have access to shared variables and helpers also. The params are automatically layered together based on `LONO_ENV`. The params are covered in more detail in [params]({% link _docs/params.md %}).
config/variables | This is where your shared variables that made are available `app/definitions`, `app/templates`, and `config/parameters` are defined. The variables are automatically layered together based on `LONO_ENV`. The variables are covered in more detail in [variables configuration]({% link _docs/shared-variables.md %}).
output | This is where the generated files like CloudFormation templates and parameter files are written to. These files can be used with the raw `aws cloudformation` CLI commands. The templates are covered in more detail in [here]({% link _docs/app-definitions.md %}).

That hopefully give you a basic idea for the lono directory structure.

