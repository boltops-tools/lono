---
title: Layering
categories: core
order: 5
nav_order: 17
---

<div class="video-box"><div class="video-container"><iframe src="https://www.youtube.com/embed/oE2vEEUu6qc" frameborder="0" allowfullscreen=""></iframe></div></div>

Lono supports a concept called layering.  Layering is how lono merges multiple files together to produce a final result.  This is useful for building multiple environments. For example, it is common to build separate production and development environment.  Most of the infrastructure is the same except for a few parts that require specific environment overrides.  Lono's layering ability makes this task simple to do.

## Variables Layering Support

Variables support layering details are here: [Variables Layering Support]({% link _docs/layering/variables.md %})

## Params Layering Support

Params support layering details are here: [Params Layering Support]({% link _docs/layering/params.md %})

## Summary

Lono's layering concept provides you with the ability to define common infrastructure components and override them for specific environments when necessary. This helps you build multiple environments in an organized way. The layering processing happens for these lono components:

* [configs/BLUEPRINT/variables]({% link _docs/configs/shared-variables.md %}) - your shared variables available to all of your templates.
* [configs/BLUEPRINT/params]({% link _docs/configs/params.md %}) - the runtime parameters you would like the stack to be launched with.

{% include prev_next.md %}
