---
title: App Scripts
---

Often times it is useful to be able to upload some custom scripts to the server and run them. One way to do this is to first upload the scripts to s3 and then download them down onto the server as part of the user-data script.  Lono supports this deployment flow with the `app/scripts` folder.

Any scripts added to the `app/scripts` folder will get uploaded to a configured s3_folder on [settings.yml]({% link _docs/settings.md %}) file.  The process is integrated to the `lono cfn create` and `update` command flow.

The `app/scripts` folder
