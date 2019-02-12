---
title: Settings
nav_order: 49
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
  # If s3_folder is set then the generated templates and app/scripts will automatically be uploaded to s3.
  # There are 2 formats for s3_folder:
  # Format 1:
  # s3_folder: mybucket/path/to/folder # simple string
  # Format 2:
  # s3_folder: # Hash options in order to support multiple AWS_PROFILEs
  #   default: mybucket/path
  #   aws_profile1: mybucket/path
  #   aws_profile2: another-bucket/storage/path
  # stack_name_suffix: random # tack on a 3 char random string at the end of the stack name for lono cfn create
  # s3_endpoint: https://s3.us-east-1.amazonaws.com  # Allows using a bucket in a different region than the stack.  Gets rid of WARNING: S3 client configured for "us-east-1" but the bucket "xxx" is in "us-west-2"; Please configure the proper region to avoid multiple unnecessary redirects and signing attempts.

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
stack_name_suffix  | This is a convenience flag that results in lono automatically appending a string to your stack name.  The string gets appended to the stack name, but gets removed internally so that lono can use its [conventions]({% link _docs/conventions.md %}). This may speed up your development flow when you are launching many stacks repeatedly. It is explained in more detail here: [Stack Name Suffix]({% link _docs/configuration/stack-name-suffix.md %}). Default: false
s3_folder  | This allows you to specify the base folder telling lono where to upload files to s3.  [app/scripts]({% link _docs/erb/app-scripts.md %}) files are uploaded in the scripts subfolder in here and templates when using lono with [nested stacks]({% link _docs/erb/nested-stacks.md %}) are uploaded in the templates subfolder.
extract_scripts | This configures how the `extract_scripts` helper works.  The extract_script helpers can take some options like `to` to specify where you want to extract `app/scripts` to.  The default is `/opt`, so scripts end up in `/opt/scripts`.

{% include prev_next.md %}