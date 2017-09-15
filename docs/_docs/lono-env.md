---
title: LONO_ENV
---

Lono's behavior is controlled by the `LONO_ENV` environment variable.  For example, the `LONO_ENV` variable is used to layer different lono files together to make it easy to define multiple environments like production and staging.  This is covered thoroughly in the [Layering]({% link _docs/layering.md %}) section.  `LONO_ENV` defaults to `prod` when not set.

### Setting LONO_ENV

The `LONO_ENV` can be set easily in several ways:

1. At the CLI command invocation - This takes the highest precedence.
2. Exported as an environment variable to your shell - This takes the second highest precedence.
3. As a `aws_profile_lono_env_map` value in your `lono/settings.yml` file - This takes the lowest precedence.

### At the CLI Command

```sh
LONO_ENV=prod lono generate
```

### As an environment variable

```sh
export LONO_ENV=prod
lono generate
```

Most people will set `LONO_ENV` in their `~/.profile`.

### In lono/settings.yml

The most interesting way to set `LONO_ENV` is with the `aws_profile_lono_env_map` in `lono/settings.yml`.  Let's say you have a `~/.lono/settings.yml` with the following:

```yaml
aws_profile_lono_env_map:
  default: dev
  my-prod-profile: prod
  my-stag-profile: stag
```

In this case, when you set `AWS_PROFILE` to switch AWS profiles, lono picks this up and maps the `AWS_PROFILE` value to the specified `LONO_ENV` using the `aws_profile_lono_env_map` lookup.  Example:

```sh
AWS_PROFILE=my-prod-profile => LONO_ENV=prod
AWS_PROFILE=my-stag-profile => LONO_ENV=stag
AWS_PROFILE=default => LONO_ENV=dev
AWS_PROFILE=whatever => LONO_ENV=dev
```

Notice how `AWS_PROFILE=whatever` results in `LONO_ENV=dev`.  This is because the `default: dev` map is specially treated. If you set the `default` map, this becomes the default value when the profile map is not specified in the rest of `lono/settings.yml`.  More info on settings is available at [settings]({% link _docs/settings.md %}).

<a id="prev" class="btn btn-basic" href="{% link _docs/directory-structure.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/import-template.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
