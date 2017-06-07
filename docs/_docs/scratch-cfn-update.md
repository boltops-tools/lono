---
title: Update the Stack
---

Let's add a route53 record to the template and update the stack. We will do this by specifying the `--template` option to use instance_and_route as the template and parameter files instead of single_instance.  Run the following command:

```sh
lono cfn update example --template instance_and_route53
```

The output show look similiar to this:

<img src="/img/tutorial/cfn-update.png" alt="Stack Update" class="doc-photo">

Notice that before the update gets performed lono provides a preview of the changes that are about to take place. There are actually types of previews.

1. Source code diff of the old existing template vs the new generated template
2. CloudFormation Change Set list of changes.

You are prompted with an "Are you sure?" confirmation before lono continues.

<a class="btn btn-basic" href="{% link _docs/scratch-cfn-create.md %}">Back</a>
<a class="btn btn-primary" href="{% link _docs/scratch-cfn-preview.md %}">Next Step</a>
