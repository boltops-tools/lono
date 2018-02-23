### The lono cfn command

Lono provides `lono cfn` lifecycle management commands that allow you to launch stacks using the generated lono templates. The `lono cfn` commands automatically runs `lono generate` internally before launching the CloudFormation stack.  This enables you to do everything in a single command. Provided that you are in a lono project and have a `mystack` lono template definition. To create the stack you simply run::

```
$ lono cfn create mystack
```

The above command will generate files to `output/templates/mystack.json` and `output/params/mystack.txt` and use them to create a CloudFormation stack. Here are some more examples of cfn commands::

```
$ lono cfn create mystack-$(date +%Y%m%d%H%M%S) --template mystack --params mystack
$ lono cfn create mystack # shorthand if template and params file matches.
$ lono cfn diff mystack
$ lono cfn preview mystack
$ lono cfn update mystack
$ lono cfn delete mystack
$ lono cfn create -h # getting help
```

