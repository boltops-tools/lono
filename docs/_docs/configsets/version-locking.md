---
title: Version Locking
nav_text: Version Locking
categories: configsets
order: 6
nav_order: 29
---

You have a lot of control over which configset version to use.

## Project Configsets: Standard Gemfile

[Project configsets]({% link _docs/configsets/project.md %}) versions can be specified in a standard Gemfile. This means all standard [bundler Gemfile options](https://bundler.io/man/gemfile.5.html) are available. Some examples:

Gemfile:

```ruby
gem "awslogs", "0.1.0", git: "git@github.com:boltopspro/awslogs"
gem "ruby", ">= 0.5.5", "< 0.8.8", git: "git@github.com:boltopspro/ruby"
gem "ssm", "~> 0.2", git: "git@github.com:boltopspro/ssm" # pessimistic version
```

The pessimistic version `ssm ~> 0.2` example means configset version 0.2 or great will be used. However, the next major version bump will not be used, IE: 1.0.0.  More info about the [pessimistic operation here](https://thoughtbot.com/blog/rubys-pessimistic-operator).

The configset version is locked by bundler and your Gemfile. In the configset declaration, you do not have to specify version numbers. Example:

configs/ec2/configsets/base.rb:

```
configset "awslogs", resource: "Instance"
configset "ruby", resource: "Instance"
configset "ssm", resource: "Instance"
```

## Git Options

Git repository sources support additional options: `branch`, `tag`, and `ref`. Only *one* of these options are allowed to be used. The default is `branch: "master"`. Examples:

Gemfile:

```ruby
gem "awslogs", git: "git@github.com:boltopspro/awslogs", branch: "master"
gem "cfn-hup", git: "git@github.com:boltopspro/cfn-hup", ref: "7212d17"
gem "httpd", git: "git@github.com:boltopspro/httpd", tag: "v0.1.0"
```

## Blueprint Configsets: Materialized

Blueprints can use configsets. Blueprints configure configsets their `config/configsets.rb` file.  Example:

config/configsets.rb:

```ruby
configset "ruby", resource: "Instance"
```

When the configset is not declared anywhere else in the [Lookup Locations]({% link _docs/lookup-locations/blueprint-configsets.md %}), Lono materializes and uses the latest version.  If a version is has be specified and is in a Lookup location with higher precedence, then that version will be used.

## Blueprint Configsets: Advanced Locking

It is also possible to specify the version in the blueprint configset declaration. Example:

```ruby
configset "ruby", "~> 0.1", resource: "Instance"
```

Lono will then materialize the specific version.

Note: You can still override the version to use by specifying their own version in their project's Gemfile. You can also create a configset with the same name in a [Blueprint Configsets Search Locations]({% link _docs/lookup-locations/blueprint-configsets.md %}) with higher precedence.

The [bundler Gemfile](https://bundler.io/man/gemfile.5.html) options are supported in the `configset` method. Examples:

```ruby
configset "ruby", resource: "Instance", branch: "master"
configset "cfn-hup", resource: "Instance", ref: "7212d17"
configset "toolset", resource: "Instance", tag: "v0.1.0"
```

## Meta: depends_on

Configsets can depend on other configsets. You can specify versions in the `depends_on` method also.

```ruby
depends_on "amazon-linux-extras", "0.1.0"
```

Note: Once again, you can still override the version with your own project Gemfile or defining configset with the same name in a [Blueprint Configsets Search Locations]({% link _docs/lookup-locations/blueprint-configsets.md %}) with higher precedence. Ultimately, this means you have control over which to version to use.

{% include prev_next.md %}
