---
title: Update the Stack
---

Let's add a route53 record to the template and update the stack.

First, create an additional params file at `params/base/instance_with_route53.txt` and add the following to it:

```sh
KeyName=tutorial
InstanceType=t2.micro
HostedZoneName=subdomain.example.local.
Subdomain=testsubdomain
```

Now we can update the stack by using the `--template instance_and_route`.  Run the following command:

```sh
lono cfn update example --template instance_and_route53
```

The output should look similiar to this:

<img src="/img/tutorial/cfn-update.png" alt="Stack Update" class="doc-photo">

Notice that before the update gets performed lono provides a preview of the changes that are about to take place. There are actually two types of "diffs" in the previews.

1. Source code diff of the templates. This is generated via downloading the current CloudFormation template and comparing it with the locally generated one using `diff`.
2. CloudFormation Change Set list of changes. This is generated using [AWS CloudFormation Change Set](https://medium.com/boltops/a-simple-introduction-to-cloudformation-part-4-change-sets-dry-run-mode-c14e41dfeab7) feature.

You are prompted with an "Are you sure?" confirmation before lono continues.

By default, the update command will display a preview of the stack changes before applying the update and prompt to check if you are sure.  If you want to bypass the are you sure prompt, use the `--sure` option.

```
lono cfn update example --template instance_and_route53 --sure
```

<a id="prev" class="btn btn-basic" href="{% link _docs/tutorial-cfn-create.md %}">Back</a>
<a id="next" class="btn btn-primary" href="{% link _docs/tutorial-cfn-preview.md %}">Next Step</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>

