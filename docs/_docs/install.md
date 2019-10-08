---
title: Installation
nav_order: 5
---

## RubyGems

You can also install lono via RubyGems.

    gem install lono

This allows you to use lono as a standalone command.

## Bundler

You can also it to your Gemfile and run `bundle` to install it.

```ruby
gem "lono"
```

## Lono Pro Addon

The lono-pro addon gem provides extra commands like `lono code convert`, which converts YAML or JSON CloudFormation templates to Ruby code.  The lono-pro addon is currently free for a limited of time. For more details: [Lono Community Edition vs Pro]({% link _docs/ce-vs-pro.md %}).

Add the gem to your Gemfile.

```ruby
gem "lono-pro"
```

And then use bundler:

    bundle install

{% include prev_next.md %}
