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

If you are a [BoltOps Pro Customer](https://www.boltops.com/pro), you'll have access to the private repo with the [lono-pro](https://github.com/boltopspro/lono-pro) addon.  Add the repo to your Gemfile.

```ruby
gem "lono-pro", git: "git@github.com:boltopspro/lono-pro.git"
```

And then use bundler:

    bundle install

{% include prev_next.md %}
