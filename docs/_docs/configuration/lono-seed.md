---
title: Lono Seed
nav_order: 74
---

For each blueprint and CloudFormation template, you will usually need to set up some [configs]({% link _docs/core/configs.md %}). To help with this, Lono has a `lono seed` command that generates starter configs values.

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

### Params

As mentioned, the parameter starter values are inferred from the template definition itself.  Not only is the parameter list derived from the template, example values are also parsed from the Description attribute.  Anything after the `IE:` or `Example:` text will be used as the starter parameter value.  Here's an example:

```ruby
parameter("Subnets", Description: "Subnets in the VPC. Example: subnet-111, subnet-222 # at least 2 subnets required")
```

The [lono seed](https://lono.cloud/reference/lono-seed/) command will generate this:

```
Subnets=subnet-111, subnet-222 # at least 2 subnets required
```

The code self-documents the starter parameters!

NOTE: Currently, parameter starter value inference is supported with the DSL form only.

### Variables

The variables starter file is generated based on the `seed/configs.rb` file in the blueprint. The general structure looks like this:

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
