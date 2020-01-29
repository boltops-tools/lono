    app/blueprints/demo
    ├── app
    │   ├── helpers
    │   ├── templates
    │   │   └── demo.rb
    │   └── user_data
    │       └── bootstrap.sh
    ├── demo.gemspec
    └── seed
        └── configs.rb

Within the blueprint folder, lono uses the files under the `app` folder and your projects [configs]({% link _docs/core/configs.md %}) files to generate CloudFormation templates and launch stacks.  The template is the component you'll usually work mostly with, IE: `app/templates/demo.rb`.

## Files and Folders Within Blueprint

File / Folders  | Description
------------- | -------------
app/helpers | Define your custom helpers here. The custom helpers are made available to templates, variables, and params. Helpers are covered in detail in [custom helpers]({% link _docs/dsl/components/custom-helpers.md %}).
app/templates | Where CloudFromation templates are defined.  Refer to the [DSL docs]({% link _docs/dsl.md %}) for the syntax.
app/user_data | Where user_data scripts live. You can include the user data script into your code with the user_data [builtin helper]({% link _docs/dsl/components/builtin-helpers.md %})
demo.gemspec | Where the gem specs and dependencies are defined.  Blueprints make use of gemspecs to handle dependencies.
seed/configs.rb | Where a setup script can be defined to work with [lono seed]({% link _docs/configuration/lono-seed.md %}).
