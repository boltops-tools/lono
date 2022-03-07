## Blueprint Helpers

When the `--blueprint` option is used a blueprint helper is generated.

The default name is custom

    $ lono new helper --blueprint demo
          create  app/blueprints/demo/helpers/custom_helper.rb

Here's an example with a helper named vars.

    $ lono new helper vars --blueprint demo
          create  app/blueprints/demo/helpers/vars_helper.rb

## Project Helpers

When no `--blueprint` option is used a project helper is generated.

The default name is custom.

    $ lono new helper
          create  app/helpers/custom/custom_helper.rb

Here's an example with a helper named common.

    $ lono new helper common
          create  app/helpers/common/common_helper.rb
