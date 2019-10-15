---
title: Lono Seed
nav_order: 52
---

For each blueprint and CloudFormation template, you will usually need to setup some configs files. Lono has a `lono seed` command that generates starter configs values.

* The starter values for params are determined by the template definition itself.
* The starter values for variables are determined by the bluperint's `seed/configs.rb`, usually written by the author.

## Usage

The general form is:

    lono seed BLUEPRINT

## Seed Example

Here's an example of using seed.

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

The ecs-asg blueprint only requires a params config file, so only the params is generated.

## Authoring

Here are suggestions if you are authoring your own `seed/configs.rb` the general structure looks like this:

```ruby
class Configs < Lono::Configure::Base
  # Setup hook
  def setup
    # Custom setup logic
    # set_instance_variables
  end

  # Template for params
  def params
    <<~EOL
      Parameter1=StarterValue1
      Parameter2=StarterValue1
      # Optional
      # Parameter3=OptionalStarterValue1
    EOL
  end

  # Template for variables
  # def variables
  #   <<~EOL
  #     Variable1=StarterValue1
  #     Variable2=StarterValue1
  #   EOL
  # end

private
  # Example:
  # def set_instance_variables
  #   @instance_type = "t3.micro"
  # end
end
```

Here are some suggestions:

* Allow the user to simply run `lono seed BLUEPRINT` without any arguments. This keeps interface simple and consistent.
* Use the helper: `get_input` to gather input from the user. Perform the logic in one spot at the beginning, so the user gets interrupted only at one place.
* Make use of lono seed helpers to get what data you need to configure the params for the blueprint right.  Here's the source of the [lono seed helpers](https://github.com/tongueroo/lono/blob/master/lib/lono/configure/helpers.rb)
* Document how to use configure in the README.md of your blueprint. This would be a good place to also show an example of a `seeds/your-blueprint/development.yml` file for your specific blueprint.

{% include prev_next.md %}
