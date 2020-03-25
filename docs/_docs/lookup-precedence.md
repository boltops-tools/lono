---
title: Lookup Precedence
nav_order: 80
---

Lono components have flexible lookup locations. This provides you with control and the power to override and customize components when necessary.

{% assign lookup_docs = site.docs | where: "categories","lookup" | sort: "order" %}
{% for doc in lookup_docs -%}
* [{{doc.title}}]({{doc.url}})
{% endfor %}

{% include prev_next.md %}
