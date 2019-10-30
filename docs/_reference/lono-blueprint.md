---
title: lono blueprint
reference: true
---

## Usage

    lono blueprint SUBCOMMAND

## Description

blueprint subcommands

## Examples

    lono blueprint new ec2 # skeleton blueprint with barebones structure

## Example Output

    $ lono blueprint new ec2
    => Creating new blueprint called ec2.
          create  ec2
          create  ec2/ec2.gemspec
          create  ec2/.gitignore
          create  ec2/Gemfile
          create  ec2/README.md
          create  ec2/app/definitions/base.rb
          create  ec2/seed/configs.rb
          create  ec2/app/templates
    => Initialize git repo
             run  git init from "."
    Initialized empty Git repository in /home/ec2-user/environment/infra/blueprints/ec2/.git/
    => Installing dependencies with: bundle install
    ================================================================
    Congrats  You have successfully created a lono blueprint.

    Cd into your blueprint and check things out.

      cd ec2

    More info: https://lono.cloud/docs/core/blueprints

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

## Subcommands

* [lono blueprint list]({% link _reference/lono-blueprint-list.md %}) - Lists project blueprints
* [lono blueprint new]({% link _reference/lono-blueprint-new.md %}) - Generates new lono blueprint.

## Options

```
-f, [--force]                    # Overwrite files that already exist
-p, [--pretend], [--no-pretend]  # Run but do not make any changes
-q, [--quiet], [--no-quiet]      # Suppress status output
-s, [--skip], [--no-skip]        # Skip files that already exist
```

