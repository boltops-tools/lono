---
title: Lono Seed
nav_order: 52
---

You usually need to setup and configure some parameter values to use each CloudFormation template. Lono introduces a configure concept to help wih this.  If the blueprint has provided a `setup/configs.rb` file then you can use `lono seed` to quickly set up some default [params]({% link _docs/configs/params.md %}) and [variables]({% link _docs/configs/shared-variables.md %}) files.

## Usage

The general form is:

    lono seed BLUEPRINT

## Seeds

Depending on how the `setup/configs.rb` was authored, if the author used the `get_input` method then prompts can bypassed and seeded with values.  Here's an example of a seed file:

seeds/vpc-peer/development.yml:

```yaml
---
requester_vpc: vpc-111
accepter_vpc: vpc-222
```

Running the lono seed vpc-peer produces something like this:

    $ lono seed vpc-peer --seed seeds/vpc-peer/development.yml
    Setting up starter values for vpc-peer blueprint
    For requester_vpc, using seed value vpc-111
    For accepter_vpc, using seed value vpc-222
    The vpc-peer blueprint configs are in:

      * configs/vpc-peer/params/development.txt
      * configs/vpc-peer/variables/development.rb

    The starter values are specific to your AWS account. They meant to
    be starter values. Please take a look, you may want to adjust the values.
    $

Additionally, there are the `--seed` option does not require you to specify a path if you have placed the seed file according to the `seeds/BLUEPRINT/LONO_ENV.yml` convention.

These are the same:

    lono seed vpc-peer
    lono seed vpc-peer --seed seeds/vpc-peer/development.yml

These are also the same:

    LONO_ENV=production lono seed vpc-peer
    lono seed vpc-peer --seed seeds/vpc-peer/production.yml

## Prompts

If seed values are not provided, then the `lono seed` command will prompt the user for input values.

Here's an example with a ec2 blueprint.

    $ lono seed ec2
    Setting up starter values for ec2 blueprint
    Please provide value for subnet_id (default: default_subnet):
    The ec2 blueprint configs are in:

      * configs/ec2/params/development.txt
      * configs/ec2/variables/development.rb

    The starter values are specific to your AWS account. They meant to
    be starter values. Please take a look, you may want to adjust the values.
    $

Above, the user gets prompted for input for the subnet_id value.

## Authoring

Here are suggestions if you are authoring your own `setup/configs.rb` the general structure looks like this:

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
