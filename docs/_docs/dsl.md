---
title: DSL
nav_order: 36
---

Lono provides the ability write your CloudFormation template with a DSL. The DSL is actually just Ruby code. This means we get the full power of a programming language. We can use loops, define methods, modules, etc.

While at the same time, the [Lono DSL](https://lono.cloud/docs/dsl/) stays close to the [declarative nature of CloudFormation](https://blog.boltops.com/2018/02/14/aws-cloudformation-declarative-infrastructure-code-tutorial). We get the best of both worlds.

Here's an example of what the DSL looks like.

{% include demo_template_ruby.md %}

Here are the top-level DSL methods.

{% assign dsl_docs = site.docs | where: "categories","dsl" %}
Method | Description
--- | ---
{% for doc in dsl_docs -%}
<a href='{{doc.url}}'>{{doc.title}}</a> | {{doc.desc}}
{% endfor %}

The main methods correspond to sections of the [CloudFormation anatomy sections](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html).

The DSL provides full access to creating custom CloudFormation stacks and AWS resources.  It is also easy wrap the DSL with your own [Helpers]({% link _docs/dsl/components/custom-helpers.md %}). This helps you keep your code concise and more readable.

{% include prev_next.md %}
