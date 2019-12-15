---
title: DSL Extras
nav_order: 47
---

Most Lono DSL methods match closely to the [CloudFormation Template Anatomy](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html) section. Additionally, there are some DSL extra methods that are useful.

{% assign dsl_docs = site.docs | where: "categories","dsl-extras" %}
Method | Description
--- | ---
{% for doc in dsl_docs -%}
<a href='{{doc.url}}'>{{doc.title}}</a> | {{doc.desc}}
{% endfor %}

{% include prev_next.md %}
