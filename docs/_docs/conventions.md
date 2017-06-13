---
title: Conventions
---

Lono follows a set of naming conventions to encourage best practices in a naming scheme. This also dramatically allows lono commands to be concise and memorable.  These conventions are followed by all the `lono cfn` commands: `create`, `update`, `preview`, etc.

By convention, the template name is the same as the stack name.  In turn, the param name will default to template name.

* stack - This is a required parameter and is the CLI first parameter.
* template - By convention matches the stack name but can be overriden with `--template`.
* param - By convention matches the template name but can be overriden with `--param`.

For example, these two commands are the same:

Long form:

```
$ lono cfn create my-stack --template my-stack --param --my-stack
```

Short form:

```
$ lono cfn create my-stack
```


Both template and param conventions can be overridden.  Here are examples of overriding the template and param naming conventions.

```
$ lono cfn create my-stack --template different-name1
```

The template that will be use is `output/different-name1.json` and the parameters that will use `param/different-name1.json`.

```
$ lono cfn create my-stack --param different-name2
```

The template that will be use is `output/my-stack.json` and the parameters that will use `param/different-name2.json`.

```
$ lono cfn create my-stack --template different-name3 --param different-name4
```

The template that will be use is `output/different-name3.json` and the parameters that will use `param/different-name4.json`.

<a id="prev" class="btn btn-basic" href="{% link _docs/existing.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/lono-help.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
