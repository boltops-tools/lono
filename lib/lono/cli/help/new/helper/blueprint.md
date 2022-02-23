## Example

The default helper name is `custom`.

    $ lono new helper blueprint --blueprint demo
    => Generating custom_helper.rb
          create  app/blueprints/demo/helpers
          create  app/blueprints/demo/helpers/custom_helper.rb


You can override the helper name with the first argument.

    $ lono new helper blueprint vars --blueprint demo
    => Generating vars_helper.rb
          create  app/blueprints/demo/helpers
          create  app/blueprints/demo/helpers/vars_helper.rb
    $
