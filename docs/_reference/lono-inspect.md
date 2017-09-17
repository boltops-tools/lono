---
title: lono inspect
---

Lono inspect is provides commands to help you quickly understand a CloudFormation template. Here are some examples.

### Summarize CloudFormation template parameters

```sh
lono inspect params my-stack
```

The above command lists out the required and optional parameters in a CloudFormation template.

### Dependency Chart

With more complex CloudFormation templates, the dependency can get more difficult to follow.  It is helpful to visualize the dependencies.

```sh
lono inspect depends my-stack
```

This above command generates a dependency chart.  The command uses the DependsOn attribute specified in each resource to figure this out.  It does not show implied dependencies that CloudFormaton automatically computes for us.

<a id="prev" class="btn btn-basic" href="{% link articles.md %}">Back</a>
<p class="keyboard-tip">Pro tip: Use the <- and -> arrow keys to move back and forward.</p>
