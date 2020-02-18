Configs are how you can customize the blueprints to fit your needs.  There are two main types of configs: [Params docs]({% link _docs/configs/params.md %}) and [Variables docs]({% link _docs/configs/shared-variables.md %}). Params allow you to affect the templates at run-time. Variables configs allow you to affect the templates at compile-time.

## Location

The `configs` files are located at the top-level of your lono project, outside of the blueprints themselves.  Example:

    configs/
    ├── ec2
    │   └── params
    │       ├── development.txt
    │       └── production.txt
    └── ecs-spot
        ├── params
        │   ├── development.txt
        │   └── production.txt
        └── variables
            ├── development.rb
            └── production.rb

## Param Files

Params are configs that you define to affect how the templates behave at runtime.  Param files provide a simple way of building parameters for CloudFormation templates. The param files use a simple `key=value` format like env files. The params are defined in the `params` folder.  More information on param files is available on the [Params docs]({% link _docs/configs/params.md %}).

## Shared Variables

Shared Variables are configs that you define to affect how the templates are generated at compile-time.  Shared variables are available to all templates, helpers, and parameters.  The variables are defined in the `configs/BLUEPRINT/variables` folder.  The variable configuration component is covered in detailed at the [Shared Variables docs]({% link _docs/configs/shared-variables.md %}).
