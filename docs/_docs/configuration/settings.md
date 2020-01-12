---
title: Settings
nav_order: 72
---

Lono's behavior can be tailored using a `settings.yml` file. This file should be created at `~/.lono/settings.yml` or `configs/settings.yml` within the project.  The options from the files get merged with the following precedence:

1. current folder - The current folder's `configs/settings.yml` values take the highest precedence.
2. user - The user's `~/.lono/settings.yml` values take the second highest precedence.
3. default - The [default settings](https://github.com/tongueroo/lono/blob/master/lib/lono/default/settings.yml) bundled with the tool takes the lowest precedence.

Let's take a look at an example `lono/settings.yml`:

```yaml
# The base config is specially treated. It gets included the other environments automatically.
base:
  # extract_scripts:
  #   to: "/opt"
  #   as: "ec2-user"
  # stack_name_suffix: random # tack on a 3 char random string at the end of the stack name for lono cfn create

development:
  # The aws_profile tightly binds LONO_ENV to AWS_PROFILE and vice-versa.
  # aws_profile: dev_profile

production:
  # The aws_profile tightly binds LONO_ENV to AWS_PROFILE and vice-versa.
  # aws_profile: prod_profile
```

The table below covers what each setting does:

Setting  | Description
------------- | -------------
aws_profile  | This provides a way to tightly bind `LONO_ENV` to `AWS_PROFILE`.  This prevents you from forgetting to switch your `LONO_ENV` when switching your `AWS_PROFILE` thereby accidentally launching a stack in the wrong environment. More details are explained in the [LONO_ENV docs]({% link _docs/configuration/lono-env.md %}).
extract_scripts | This configures how the `extract_scripts` helper works.  The extract_script helpers can take some options like `to` to specify where you want to extract `app/scripts` to.  The default is `/opt`, so scripts end up in `/opt/scripts`.

{% include prev_next.md %}
