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

Lono prompts you with an "Are you sure?" message before the stack gets deleted.  If you would like to bypass the prompt, you can use the `--sure` flag.

```
$ lono cfn delete example --sure
Deleted example stack.
$
```

Congratulations! 🎉 You have successfully created a lono project from scratch!

<a id="prev" class="btn btn-basic" href="{% link _docs/tutorial-cfn-preview.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial-new.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

