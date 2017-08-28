---
title: Settings
---

Lono's behavior can be tailored using a `lono/settings.yml` file. This file should be created at `~/.lono/settings.yml` or `lono/settings.yml` within the project.  The options from the files get merged with the following precedence:

1. current folder - The current folder's `lono/settings.yml` values take the highest precedence.
2. user - The user's `~/.lono/settings.yml` values take the second highest precedence.
3. default - The [default settings](https://github.com/tongueroo/lono/blob/master/lib/lono/default/settings.yml) bundled with the tool takes the lowest precedence.

Let's take a look at an example `lono/settings.yml`:

```yaml
aws_profile_lono_env_map:
  default: prod
  bolt-stag: stag
  aws_profile2: dev
s3:
  enabled: true
  path:
    default: # default is nil.
    # More examples on how to specify different buckets for different LONO_ENV
    # prod: mybucket/path
    # stag: another-bucket/storage/path
randomize_stack_name: false
```

The table below covers what each setting does:

Setting  | Description
------------- | -------------
`aws_profile_lono_env_map`  | This provides a way to automatically map your `AWS_PROFILE` to a `LONO_ENV`. This prevents you from forgetting to switch your `LONO_ENV` when switching your `AWS_PROFILE` thereby accidentally launching a stack meant to be in the stag account on the prod account and vice versa. More details are explained in the `LONO_ENV` docs.
`s3.path`  | This allows you to specify the base path telling lono where to upload the files to s3.
`randomize_stack_name`  | This is a convenience flag that results in lono automatically appending a random string to your stack name with the `lono cfn` lifecycle commands that speeds up your development flow when you are launching many stacks repeatedly. Default: false

### The randomize_stack_name setting

The `randomize_stack_name` is an option that was added after realizing a common development flow pattern that was being used repeatedly. When working with CloudFormation templates and developing the source code we must often launch stacks over and over as we fine tune the stack. Since we cannot launch a stack with a duplicate name it is useful to use a command like this:

```sh
lono cfn create my-stack-$(date +%s) --template my-stack
```

This command automatically adds a random string to the end of the stack name so we can quickly run the same command to launch multiple stacks in rapid fire fashion and debug.

The `randomize_stack_name` option automates this. When the option is enabled.

```sh
lono cfn create my-stack
```

Will create a my-stack-[RANDOM] using the my-stack template name.  The random string is a short 3 character string.

<a id="prev" class="btn btn-basic" href="{% link _docs/conventions.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/nested-stacks.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
