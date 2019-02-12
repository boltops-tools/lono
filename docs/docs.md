---
title: Docs
nav_order: 2
---

Lono is a CloudFormation framework tool that helps you manage your templates.  Lono handles the entire CloudFormation lifecycle. It starts with helping you develop your templates and helps you all the way to the infrastructure provisioning step.

{:.overview-stages}
1. The first stage of lono is you crafting and writing the CloudFormation templates. Lono enables you to write your CloudFormation templates in a [DSL]({% link _docs/dsl.md %}) or [ERB]({% link _docs/erb.md %}) templating language. Once you are ready, then you can generate the templates with `lono generate`.
2. You then specify the desired parameters to use for the CloudFormation template. You do this with simple env-like param files. The format is easy on the eyes.
3.  In the end, lono puts it all together and launches the stack for you. It takes what is normally a manual multi-step process and simplifies it down to a single command: `lono cfn deploy`.

Here is a diagram that describes how lono works.

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

## Lono Features

* Generates standard CloudFormation templates from a [DSL]({% link _docs/dsl.md %}) or [ERB]({% link _docs/erb.md %}) templates.
* Allows you to write your CloudFormation parameters files in a simple env-like file.
* Provides a simple command line interface to deploy, delete and preview CloudFormation changes.
* Supports layering which allows you to build multiple environments like development and production quickly.
* Supports compile time variables, which allow to construct templates where runtime Parameters do not suffice.
* Provides helpers support to allow you to extend Lono and simplify code.

{% include prev_next.md %}