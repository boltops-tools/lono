---
title: App Files
---

If you already have pre-existing files like zip files that need to be uploaded to s3, you can put them in `app/files`.  When the s3_folder option is configured in [settings.yml]({% link _docs/settings.md %}) the files in `app/files` automatically get uploaded as part of the `lono cfn` commands. The files get uploaded to `[S3_FOLDER]/[LONO_ENV]/app/files`. For example, given a file in `app/files/lambda-function.zip` and these settings:

```
development:
  s3_folder:
    default: s3://my-bucket/cloudformation
```

The file will upload to this s3 path:

Local path | S3 path
--- | ---
app/files/lambda-function.zip | s3://my-bucket/cloudformation/development/files/lambda-function.zip

<a id="prev" class="btn btn-basic" href="{% link _docs/app-scripts.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/builtin-helpers.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
