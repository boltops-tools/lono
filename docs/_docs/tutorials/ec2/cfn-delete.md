---
title: Delete the Stack
---

We covered `lono cfn delete` earlier. For completeness, we'll cover it at the end again.  Let's clean up any resources we no longer want.  You can delete the stack with the following command:

```sh
$ lono cfn delete ec2
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

Congratulations! 🎉 You have successfully gone through the lono introductory tutorial. You've created stacks, edit them, and updated them. Hopefully, you've got a good sense of how lono works.  There is much more lono can do. Here are some additional links to learn more:

* [Scripts]({% link _docs/erb/app-scripts.md %}) - Scripts that get automatically uploaded and available to you.
* [Helpers]({% link _docs/erb/helpers/builtin-helpers.md %}) - Built-in helpers and custom helpers are supported.
* [Params]({% link _docs/configs/params.md %}) - Params have layering and shared variables support which can sometimes simplify your param files.
* [Nested Stacks]({% link _docs/erb/nested-stacks.md %}) - Helpers exists to support nested stacks.