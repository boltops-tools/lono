---
title: Conventions
nav_order: 69
---

Lono follows a set of naming conventions to encourage best practices in a naming scheme. This also dramatically allows lono commands to be shorter and hopefully more memorable.

{% assign docs = site.docs | where: "categories","conventions" %}

<ul>
{% for doc in docs -%}
  <li><a href='{{doc.url}}'>{{doc.title}} Conventions</a>: {{doc.desc}}</li>
{% endfor %}
</ul>

{% include prev_next.md %}
