---
title: LONO_ENV
nav_order: 73
---

Lono's behavior is controlled by the `LONO_ENV` environment variable.  For example, the `LONO_ENV` variable is used to layer different lono files together to make it easy to define multiple environments like production and development.  This is covered thoroughly in the [Layering docs]({% link _docs/core/layering.md %}).  `LONO_ENV` defaults to `development` when not set.

## Setting LONO_ENV

The `LONO_ENV` can be set in several ways:

1. At the CLI command invocation - This takes the highest precedence.
2. Exported as an environment variable to your shell - This takes the second highest precedence.
3. As a `aws_profile` value in your lono `settings.yml` file - This takes the lowest precedence.

## At the CLI Command

    LONO_ENV=production lono generate

## As an environment variable

    export LONO_ENV=production
    lono generate

If you do not want to remember to type `LONO_ENV=production`, you can set it in your `~/.profile`.

## Settings: aws_profile

The most interesting way to set `LONO_ENV` is with `aws_profile` in `settings.yml`.  This setting tightly binds the two environment variables: `LONO_ENV` and `AWS_PROFILE`. Let's say you have a `settings.yml` with the following:

```yaml
development:
  aws_profile: dev_profile
production:
  aws_profile: prod_profile
```

In this case, when you set `AWS_PROFILE` to switch AWS profiles, lono picks this up and maps `aws_profile` to the containing `LONO_ENV` config. This prevents you from switching `AWS_PROFILE`, forgetting to also switch `LONO_ENV`, and accidentally deploying to the wrong environment. Example:

AWS_PROFILE | LONO_ENV | Notes
--- | --- | ---
dev_profile | development
prod_profile | production
whatever | development | default since whatever is not found in settings.yml

The binding is two-way. So:

    LONO_ENV=production lono cfn deploy # will deploy to the AWS_PROFILE=prod_profile
    AWS_PROFILE=prod_profile lono cfn deploy # will deploy to the LONO_ENV=production

More info on settings is available at the [Settings docs]({% link _docs/configuration/settings.md %}).

{% include prev_next.md %}
