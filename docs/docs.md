---
title: Docs
nav_order: 3
---

Lono is a CloudFormation framework tool that helps you manage your templates.  Lono handles the entire CloudFormation lifecycle. It starts with helping you develop your templates and helps you all the way to the infrastructure provisioning step.

{:.overview-stages}
1. The first stage of lono is you crafting and writing the CloudFormation templates. Lono enables you to write your CloudFormation templates in a [DSL]({% link _docs/dsl.md %}) or [ERB]({% link _docs/erb.md %}) templating language. Once you are ready, then you can generate the templates with [lono generate](/reference/lono-generate/).
2. You then specify the desired parameters to use for the CloudFormation template. You do this with simple env-like param files. The format is easy on the eyes.
3.  In the end, lono puts it all together and launches the stack for you. It takes what is normally a manual multi-step process and simplifies it down to a single command: [lono cfn deploy](/reference/lono-cfn-deploy/).

Here is a diagram that describes how lono works.

<img src="/img/tutorial/lono-flowchart.png" alt="Stack Created" class="doc-photo lono-flowchart">

## Lono Features

* Ability to use [Existing CloudFormation Templates]({% link _docs/existing-templates.md %}).
* [The Lono DSL]({% link _docs/dsl.md %}) - Generate templates from beautiful code.
* Write your CloudFormation parameters with [simple env-like values]({% link _docs/configs/params.md %}).
* Preview CloudFormation changes before pressing the big red button.
* [Layering]({% link _docs/core/layering.md %}) - Allows you to build multiple environments like development and production with the same template.
* [Variables]({% link _docs/layering/variables.md %}) - Allows you to construct templates where runtime Parameters do not suffice.
* [Helpers]({% link _docs/core/helpers.md %}) - Allows you to extend Lono and simplify code.
* [Configsets]({% link _docs/configsets.md %}) - Configuration Management. Automatically configure EC2 instances with reuseable code.

## Lono Tutorial Series

* [Part 1: EC2 Instance](https://blog.boltops.com/2019/10/30/lono-cloudformation-framework-introduction-series-part-1-ec2-instance)
* [Part 2: EC2, EIP, and Previews](https://blog.boltops.com/2019/11/05/lono-cloudformation-framework-introduction-series-part-2-ec2-eip-and-preview)
* [Part 3: Configs Params Variables](https://blog.boltops.com/2019/11/06/lono-cloudformation-framework-introduction-series-part-3-configs-params-variables)
* [Part 4: Layering](https://blog.boltops.com/2019/11/07/lono-cloudformation-framework-introduction-series-part-4-layering)
* [Part 5: Lono Code Convert and Import](https://blog.boltops.com/2020/01/28/lono-cloudformation-framework-introduction-series-part-5-lono-code-convert)
* [Part 6: Lono Seed](https://blog.boltops.com/2020/02/03/lono-cloudformation-framework-introduction-series-part-6-lono-seed)
* [Part 7: Variables and Loops](https://blog.boltops.com/2020/02/11/lono-cloudformation-framework-introduction-series-part-7-variables-and-loops)
* [Part 8: Helpers](https://blog.boltops.com/2020/02/17/lono-cloudformation-framework-introduction-series-part-8-helpers)

## CloudFormation Introduction Series

* [Part 1: EC2 Instance](https://blog.boltops.com/2017/03/06/a-simple-introduction-to-aws-cloudformation-part-1-ec2-instance)
* [Part 2: EC2 Instance and Route53](https://blog.boltops.com/2017/03/20/a-simple-introduction-to-aws-cloudformation-part-2-ec2-instance-and-route53)
* [Part 3: Updating a Stack](https://blog.boltops.com/2017/03/24/a-simple-introduction-to-aws-cloudformation-part-3-updating-a-stack)
* [Part 4: Change Sets = Dry Run Mode](https://blog.boltops.com/2017/04/07/a-simple-introduction-to-aws-cloudformation-part-4-change-sets-dry-run-mode)
* [AWS CloudFormation Declarative Infrastructure Code Tutorial](https://blog.boltops.com/2018/02/14/aws-cloudformation-declarative-infrastructure-code-tutorial)

{% include prev_next.md %}
