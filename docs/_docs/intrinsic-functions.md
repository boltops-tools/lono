---
title: Intrinsic Functions
nav_order: 51
---

Lono provides helper methods that map to [CloudFormation Intrinsic Functions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html).

{% assign dsl_docs = site.docs | where: "categories","intrinsic-function" %}

<ul>
{% for doc in dsl_docs -%}
  <li><a href='{{doc.url}}'>{{doc.title}}</a></li>
{% endfor %}
</ul>

{% include prev_next.md %}
