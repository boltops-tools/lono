#### An overview of folders

File / Directory  | Description
------------- | -------------
`app/definitions`  | Here's where you define or declare your template definitions. It tells lono what templates to generate to the `output` folder.  You can specify template output name and source here. The templates are [automatically layered together]({% link _docs/layering.md %}) based on `LONO_ENV`.  The template blocks are covered in more detail in [templates configuration]({% link _docs/app-definitions.md %}).
`config/variables`  | Configure your global lono variables here.  This is where you specify variables that are globally available to all template blocks and template views. The variables are automatically layered together based on `LONO_ENV`. The variables are covered in more detail in [variables configuration]({% link _docs/config-variables.md %}).
`helpers`  | Define your custom helpers here. The custom helpers are made available to lono config template blocks and template views.  Helpers are covered in more detail in [custom helpers]({% link _docs/custom-helpers.md %}).
`params`  | Specific your parameters for the CloudFormation stacks to be launched. The params are automatically layered together based on `LONO_ENV`.  The params are covered in more detail in [params]({% link _docs/params.md %}).
`output`  | This is where the generated CloudFormation templates and parameter files are written to.  These files can be used with the raw `aws cloudformation` CLI commands.
`templates`  | The ERB templates with the "view" code.  The templates are covered in more detail in [template helpers](/template-helpers).

