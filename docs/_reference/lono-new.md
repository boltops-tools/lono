---
title: lono new
reference: true
---

## Usage

    lono new NAME

## Description

Generates new lono project.

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

      To deploy the blueprint:

          lono cfn deploy my-demo --blueprint demo

      If you name the stack according to conventions, you can simply run:

          lono cfn deploy demo

      To list and create additional blueprints refer to https://lono.cloud/docs/core/blueprints

    More info: https://lono.cloud/
    $


## Options

```
[--bundle], [--no-bundle]  # Runs bundle install on the project
                           # Default: true
[--demo], [--no-demo]      # Also generate demo blueprint
[--force]                  # Bypass overwrite are you sure prompt for existing files.
[--git], [--no-git]        # Git initialize the project
                           # Default: true
[--type=TYPE]              # Blueprint type: dsl or erb
                           # Default: dsl

Runtime options:
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

