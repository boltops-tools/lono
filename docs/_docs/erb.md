---
title: ERB
nav_order: 83
---

Lono provides the ability write your CloudFormation templates with ERB.

<ul>
{% assign docs = site.docs | where: "categories","erb" %}
{% for doc in docs -%}
  <li><a href='{{doc.url}}'>{{doc.title}}</a></li>
{% endfor %}
</ul>

The ERB is useful for very simple cases.  You may find the [DSL]({% link _docs/dsl.md %}) ability more useful and easier to manage though.

{% include prev_next.md %}
