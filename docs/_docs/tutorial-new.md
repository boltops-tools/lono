---
title: Tutorial: Starting with lono new
---

The first command we'll walk through is the `lono new` command.  Here's the command with some output filtered to focus on learning.

```
$ lono new autoscaling
=> Creating new project called autoscaling.
      create  autoscaling
      create  autoscaling/.gitignore
      create  autoscaling/Gemfile
      create  autoscaling/Guardfile
      create  autoscaling/README.md
      create  autoscaling/app/definitions/base.rb
      create  autoscaling/config/settings.yml
      create  autoscaling/welcome.txt
      create  autoscaling/app/helpers
      create  autoscaling/app/partials
      create  autoscaling/app/scripts
      create  autoscaling/app/templates
      create  autoscaling/app/user_data
      create  autoscaling/config/params
      create  autoscaling/config/variables
      create  autoscaling/output
=> Installing dependencies with: bundle install
Fetching gem metadata from https://rubygems.org/..
Resolving dependencies...
Using lono 3.5.0
Bundle complete! 1 Gemfile dependency, 37 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
=> Initialize git repo
         run  git init from "."
Initialized empty Git repository in /Users/tung/src/tongueroo/lono-examples/autoscaling/.git/
         run  git add . from "."
         run  git commit -m 'first commit' from "."
[master (root-commit) bd28153] first commit
 8 files changed, 215 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 Gemfile
 create mode 100644 Gemfile.lock
 create mode 100644 Guardfile
 create mode 100644 README.md
 create mode 100644 app/definitions/base.rb
 create mode 100644 config/settings.yml
 create mode 100644 welcome.txt
welcome_path "/Users/tung/src/tongueroo/lono/lib/starter_projects//welcome.txt"
================================================================
Congrats 🎉 You have successfully created a lono project.

Cd into your project and check things out:

  cd autoscaling

Add and edit templates to your project.  When you are ready to launch a CloudFormation stack run:

  lono cfn create STACK_NAME

You can also get started quickly by importing other CloudFormration templates into lono.  For example:

  lono import https://s3-us-west-2.amazonaws.com/cloudformation-templates-us-west-2/EC2InstanceWithSecurityGroupSample.template --name ec2

To re-generate your templates without launching a stack, you can run:

  lono generate

The generated CloudFormation templates are in the output/templates folder.
The generated stack parameters are in the output/params folder.  Here's the command with some output filtered to focus on learning.

More info: http://lono.cloud/
$
```

You do not have to start with an empty folder as your lono project. Normally, you use `lono new project-name` to generate a new lono project with the proper structure.  Example:

```
$ lono new infra
Setting up lono project
creating: infra/config/templates/base/stacks.rb
creating: infra/config/templates/prod/stacks.rb
creating: infra/config/templates/stag/stacks.rb
creating: infra/config/variables/base/variables.rb
creating: infra/config/variables/prod/variables.rb
creating: infra/config/variables/stag/variables.rb
already exists: infra/Gemfile
already exists: infra/Guardfile
creating: infra/helpers/my_custom_helper.rb
creating: infra/params/base/example.txt
creating: infra/params/prod/example.txt
