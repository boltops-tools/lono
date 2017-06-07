---
title: Delete the Stack
---

Now it is time to clean up the resources.  You can delete the stack with the following command:

```sh
$ lono cfn delete example
Are you sure you want to want to delete the stack? (y/N)
y
Deleted example stack.
$
```

Lono prompts with an "Are you sure?" message before the stack gets deleted.  If you would like to bypass the prompt, you can use the `--sure` flag.

```
$ lono cfn delete example --sure
Deleted example stack.
$
```

Congratulations! 🎉 You have successfully created a lono project from scratch!

<a class="btn btn-basic" href="{% link _docs/scratch-cfn-preview.md %}">Back</a>
<a class="btn btn-primary" href="{% link _docs/new.md %}">Next Step</a>
