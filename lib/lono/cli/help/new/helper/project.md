## Examples

The default helper name is `custom`.

    $ lono new helper project
    => Generating custom_helper.rb
          create  app/helpers/custom
          create  app/helpers/custom/custom_helper.rb

You can override the helper name with the first argument.

    $ lono new helper project asg
    => Generating asg_helper.rb
          create  app/helpers/asg
          create  app/helpers/asg/asg_helper.rb
    $
