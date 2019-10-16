---
title: Lono Seed
nav_order: 52
---

For each blueprint and CloudFormation template, you will usually need to setup some [configs]({% link _docs/core/configs.md %}). Lono has a `lono seed` command that generates starter configs values.

* The starter values for params are determined by the template definition itself.
* The starter values for variables are determined by the blueprint's `seed/configs.rb`, usually written by the author.

## Usage

The general form is:

    lono seed BLUEPRINT

## Seed Example

Here's an example using `lono seed`.

    $ lono seed ecs-asg
    Creating starter config files for ecs-asg
    Starter params created:    configs/ecs-asg/params/development.txt
    $ cat configs/ecs-asg/params/development.txt
    # Required parameters:
    VpcId=vpc-111
    Subnets=subnet-111,subnet-222,subnet-333
    EcsCluster=development
    # Optional parameters:
    # InstanceType=m5.large
    # KeyName=...
    # SshLocation=...
    # TagName=ecs-asg
    $

The `configs/ecs-asg/params/development.txt` file is conveniently generated for you. Depending on the blueprint, a `configs/ecs-asg/variables/development.rb` will also be generated.

Also, different `LONO_ENV` will generate corresponding configs. For example, `LONO_ENV=production` will generate  `configs/ecs-asg/params/production.txt`.

## Authoring

If you are authoring your own `seed/configs.rb`, the general structure looks like this:

```ruby
class Lono::Seed::Configs < Lono::Seed::Base
  # Template for variables
  def variables
    <<~EOL
      @variable1=value1
      @variable2=value2
    EOL
  end
end
```

Remember to document how to use `lono seed` in the README.md of your blueprint.

{% include prev_next.md %}
