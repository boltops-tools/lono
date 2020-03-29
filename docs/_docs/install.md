---
title: Installation
nav_order: 7
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

## AWS Setup

It is strongly recommended to set up the `~/.aws/config` and `~/.aws/credentials`. Here are the AWS Docs: [Set up AWS Credentials and Region for Development](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html). This allows you to switch `AWS_PROFILE` and leverage automatic `AWS_PROFILE` switching based on [LONO_ENV settings](https://lono.cloud/docs/configuration/lono-env/).

Note, if you are using `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env variables instead, you must also set the `AWS_REGION` env var.

{% include prev_next.md %}
