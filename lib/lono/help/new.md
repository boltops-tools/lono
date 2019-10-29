## Examples

    lono new infra # starter project with demo blueprint

By default, `lono new` generates a skeleton project. Use `TEMPLATE` to generate different starter projects. List of the [starter templates](https://github.com/tongueroo/lono/tree/master/lib/starter_projects).

## Example Output

    $ lono new infra
    => Creating new project called infra.
          create  infra
          create  infra/.gitignore
          create  infra/Gemfile
          create  infra/Guardfile
          create  infra/README.md
          create  infra/configs/settings.yml
    => Creating new blueprint called demo.
          create  infra/blueprints/demo
          create  infra/blueprints/demo/demo.gemspec
          create  infra/blueprints/demo/.gitignore
          create  infra/blueprints/demo/.meta/config.yml
          create  infra/blueprints/demo/Gemfile
          create  infra/blueprints/demo/README.md
          create  infra/blueprints/demo/seed/configs.rb
           exist  infra/blueprints/demo
          create  infra/blueprints/demo/app/templates/demo.rb
          create  infra/blueprints/demo/app/user_data/bootstrap.sh
           exist  infra/blueprints/demo/app/templates
           exist  infra
          create  infra/configs/demo/params/base.txt
          create  infra/configs/demo/params/development.txt
          create  infra/configs/demo/variables/base.rb
          create  infra/configs/demo/variables/development.rb
    => Initialize git repo
    => Installing dependencies with: bundle install
    => Commit git repo
    ================================================================
    Congrats  You have successfully created a lono project.  A starter demo blueprint was created
    and is at blueprints/demo.  Check things out by going into the created infra folder.

      cd infra

      To create a new blueprint run:

          lono blueprint new demo

      To deploy the CloudFormation stack:

          lono cfn deploy my-demo --blueprint demo

      If you name the stack according to conventions, you can simply run:

          lono cfn deploy demo

      To list and create additional blueprints refer to https://lono.cloud/docs/core/blueprints

    More info: http://lono.cloud/
    $