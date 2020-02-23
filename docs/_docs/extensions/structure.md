---
title: Extension Structure
nav_text: Structure
categories: extensions
order: 2
nav_order: 55
---

Here's an example lono extension structure:

    app/extensions/my_extension
    ├── lib
    │   ├── my_extension
    │   │   ├── helpers
    │   │   └── version.rb
    │   └── my_extension.rb
    └── my_extension.gemspec

File | Description | Required?
--- | --- | ---
helpers | The folder where you define helpers and extend the extension DSL. | optional
my_extension.gemspec | A standard gemspec definition.  Configure things like name and author. | required

## lono extension new

A quick way create a project extension is with the [lono extension new](/reference/include configsets/lono-extension-new.md/) command.  It will generate a skeleton extension structure in `app/extensions`.

    $ lono extension new ec2_extension
    => Creating new extension called ec2_extension.
          create  app/extensions/ec2_extension
          create  app/extensions/ec2_extension/ec2_extension.gemspec
          create  app/extensions/ec2_extension/.gitignore
          create  app/extensions/ec2_extension/.rspec
          create  app/extensions/ec2_extension/CHANGELOG.md
          create  app/extensions/ec2_extension/Gemfile
          create  app/extensions/ec2_extension/Rakefile
          create  app/extensions/ec2_extension/lib/ec2_extension.rb
          create  app/extensions/ec2_extension/lib/ec2_extension/helpers/mappings.rb
          create  app/extensions/ec2_extension/lib/ec2_extension/helpers/outputs.rb
          create  app/extensions/ec2_extension/lib/ec2_extension/helpers/parameters.rb
          create  app/extensions/ec2_extension/lib/ec2_extension/helpers/resources/resource.rb
          create  app/extensions/ec2_extension/lib/ec2_extension/helpers/variables.rb
          create  app/extensions/ec2_extension/lib/ec2_extension/version.rb
          create  app/extensions/ec2_extension/spec/spec_helper.rb
    $

{% include prev_next.md %}
