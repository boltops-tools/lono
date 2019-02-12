---
title: lono blueprint
reference: true
---

## Usage

    lono blueprint NAME

## Description

Generates new lono blueprint.

## Examples

    lono blueprint ec2 # skeleton blueprint with barebones structure

## Example Output

    $ lono blueprint ec2
    => Creating new blueprint called ec2.
          create  ec2
          create  ec2/ec2.gemspec
          create  ec2/.gitignore
          create  ec2/Gemfile
          create  ec2/README.md
          create  ec2/app/definitions/base.rb
          create  ec2/setup/configs.rb
          create  ec2/app/templates
    => Initialize git repo
             run  git init from "."
    Initialized empty Git repository in /home/ec2-user/environment/boltopspro/blueprints/ec2/.git/
    => Installing dependencies with: bundle install
    ================================================================
    Congrats  You have successfully created a lono blueprint.

    Cd into your blueprint and check things out.

      cd ec2

    More info: http://lono.cloud/docs/blueprints

      Here's the structure your blueprint:

    .
    ├── app
    │   ├── definitions
    │   │   └── base.rb
    │   └── templates
    ├── ec2.gemspec
    ├── Gemfile
    ├── Gemfile.lock
    ├── README.md
    └── setup
        └── configs.rb

    4 directories, 6 files

    $


## Options

```
[--bundle], [--no-bundle]      # Runs bundle install on the project
                               # Default: true
[--force]                      # Bypass overwrite are you sure prompt for existing files.
[--from-new], [--no-from-new]  # Called from `lono new` command.
[--project-name=PROJECT_NAME]  # Only used with from_new internally
[--type=TYPE]                  # Blueprint type: dsl or erb
                               # Default: dsl
```
