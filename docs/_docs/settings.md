---
title: Settings
---

Lono's behavior can be tailored using a `settings.yml` file. This file should be created at `~/.lono/settings.yml` or `config/settings.yml` within the project.  The options from the files get merged with the following precedence:

1. current folder - The current folder's `config/settings.yml` values take the highest precedence.
2. user - The user's `~/.lono/settings.yml` values take the second highest precedence.
3. default - The [default settings](https://github.com/tongueroo/lono/blob/master/lib/lono/default/settings.yml) bundled with the tool takes the lowest precedence.

Let's take a look at an example `lono/settings.yml`:

```yaml
# The base config is specially treated. It gets included the other environments automatically.
base:
  # extract_scripts:
  #   to: "/opt"
  #   as: "ec2-user"
  # If s3_folder is set then the generated templates and app/scripts will automatically be uploaded to s3.
  # There are 2 formats for s3_folder:
  # Format 1:
  # s3_folder: mybucket/path/to/folder # simple string
  # Format 2:
  # s3_folder: # Hash options in order to support multiple AWS_PROFILEs
  #   default: mybucket/path
  #   aws_profile1: mybucket/path
  #   aws_profile2: another-bucket/storage/path
  # randomize_stack_name: true # tack on a 3 char random string at the end of the stack name for lono cfn create

development:
  # When you have AWS_PROFILE set to one of these values, ufo will switch to the desired
  # environment. This prevents you from switching AWS_PROFILE, forgetting to
  # also switch UFO_ENV, and accidentally deploying to production vs development.
  # aws_profiles:
  #   - dev_profile1
  #   - dev_profile2

production:
  # aws_profiles:
  #   - prod_profile
```

The table below covers what each setting does:

Setting  | Description
------------- | -------------
`aws_profiles`  | This provides a way to automatically map your `AWS_PROFILE` to a `LONO_ENV`. This prevents you from forgetting to switch your `LONO_ENV` when switching your `AWS_PROFILE` thereby accidentally launching a stack meant to be in the development account on the production account and vice versa. More details are explained in the [LONO_ENV docs]({% link _docs/lono-env.md %}).
`randomize_stack_name`  | This is a convenience flag that results in lono automatically appending a random string to your stack name with the `lono cfn` lifecycle commands that speeds up your development flow when you are launching many stacks repeatedly. The random string gets appended to the stack name, but gets removed internally so that lono can use its [conventions]({% link _docs/conventions.md %}). It is explained in more detail below. Default: false
`s3_folder`  | This allows you to specify the base folder telling lono where to upload files to s3.  [app/scripts]({% link _docs/app-scripts.md %}) files are uploaded in the scripts subfolder in here and templates when using lono with [nested stacks]({% link _docs/nested-stacks.md %}) are uploaded in the templates subfolder.
`extract_scripts` | This configures how the `extract_scripts` helper works.  The extract_script helpers can take some options like `to` to specify where you want to extract `app/scripts` to.  The default is `/opt`, so scripts end up in `/opt/scripts`.

## The randomize_stack_name setting

The `randomize_stack_name` is an option that was added after realizing a common development flow pattern that was being repeatedly used. When working with CloudFormation templates and developing the source code, we must often launch stacks over and over as we fine tune the stack. Since we cannot launch a stack with a duplicate name it is useful to use a command like this:

```sh
lono cfn create my-stack-$(date +%s) --template my-stack
```

This command automatically adds a random string to the end of the stack name but uses the template name without the random string. The `randomize_stack_name` option automates this. So we can create multiple stacks with different names but the same source template rapidly.  We can create multiple stacks in rapid-fire fashion and debug.  When the option is enabled:

```sh
lono cfn create my-stack
```

Will create a "my-stack-[RANDOM]" using the my-stack template name.  The random string is a short 3 character string.

<a id="prev" class="btn btn-basic" href="{% link _docs/conventions.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/starter-templates.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
