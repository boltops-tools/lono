---
title: lono blueprint new
reference: true
---

## Usage

    lono blueprint new NAME

## Description

Generates new lono blueprint.

## Examples

    lono blueprint new demo # skeleton blueprint with barebones structure

## Example Output

    $ lono blueprint new demo
    => Creating new blueprint called demo.
          create  blueprints/demo
          create  blueprints/demo/demo.gemspec
          create  blueprints/demo/.gitignore
          create  blueprints/demo/CHANGELOG.md
          create  blueprints/demo/Gemfile
          create  blueprints/demo/README.md
          create  blueprints/demo/Rakefile
          create  blueprints/demo/seed/configs.rb
           exist  blueprints/demo
          create  blueprints/demo/app/templates/demo.rb
          create  blueprints/demo/app/user_data/bootstrap.sh
           exist  blueprints/demo/app/templates
           exist
          create  configs/demo/params/development.txt
          create  configs/demo/params/production.txt
          create  configs/demo/variables/development.rb
          create  configs/demo/variables/production.rb
    => Installing dependencies with: bundle install
    Fetching gem metadata from https://rubygems.org/..........
    ...
    Bundle complete! 4 Gemfile dependencies, 9 gems now installed.
    Use `bundle info [gemname]` to see where a bundled gem is installed.
    ================================================================
    Congrats  You have successfully created a lono blueprint.

    Cd into your blueprint and check things out.

        cd demo

    More info: https://lono.cloud/docs/core/blueprints

    Here is the structure of your blueprint:

    .
    ├── app
    │   ├── templates
    │   │   └── demo.rb
    │   └── user_data
    │       └── bootstrap.sh
    ├── CHANGELOG.md
    ├── demo.gemspec
    ├── Gemfile
    ├── Gemfile.lock
    ├── Rakefile
    ├── README.md
    └── seed
        └── configs.rb
    $


## Options

```
[--bundle], [--no-bundle]      # Runs bundle install on the project
                               # Default: true
[--demo], [--no-demo]          # Include demo template
                               # Default: true
[--force]                      # Bypass overwrite are you sure prompt for existing files.
[--from-new], [--no-from-new]  # Called from `lono new` command.
[--import], [--no-import]      # Flag for lono code import
[--project-name=PROJECT_NAME]  # Only used with from_new internally
[--type=TYPE]                  # Blueprint type: dsl or erb
                               # Default: dsl
```

