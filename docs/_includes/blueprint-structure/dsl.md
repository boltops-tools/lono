    demo
    ├── app
    │   ├── helpers
    │   ├── templates
    │   │   └── demo.rb
    │   └── user_data
    │       └── bootstrap.sh
    ├── demo.gemspec
    ├── .meta
    │   └── config.yml
    └── seed
        └── configs.rb

Lono uses the files under the `app` folder and combines them with your your projects `configs` files to generate CloudFormation templates and launch stacks.  The template is the component you'll usually work mostly with, IE: `app/templates/demo.rb`.

## Files and Folders

File / Folders  | Description
------------- | -------------
app/helpers | Define your custom helpers here. The custom helpers are made available to templates, variables, and params. Helpers are covered in detail in [custom helpers]({% link _docs/dsl/components/custom-helpers.md %}).
app/templates | Where CloudFromation templates are defined.  Refer to the [DSL docs]({% link _docs/dsl.md %}) for the syntax.
app/user_data | Where user_data scripts live. You can include the user data script into your code with the user_data [builtin helper]({% link _docs/dsl/components/builtin-helpers.md %})
demo.gemspec | Where the gem specs and dependencies are defined.  Blueprints make use of gemspecs to handle dependencies.
.meta/config.yml | Where the blueprint_name and blueprint_type is set.  The blueprint name is determined in here, not by the gem name or folder name.
seed/configs.rb | Where a setup script can be defined to work with [lono seed]({% link _docs/configuration/lono-seed.md %}).
