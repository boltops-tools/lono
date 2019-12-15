---
title: Lookup Output
category: dsl-extras
desc: Can be used in params files with ERB to lookup outputs from other stacks.
nav_order: 49
---

The `lookup_output` method can be used in [params]({% link _docs/configs/params.md %}) files to reference outputs in other stacks.

Let's say you have deployed a stack named `vpc`.

    lono cfn deploy vpc

The vpc stack has been designed with a `VpcId` output.

Then you would like to launch another stack that has a `VpcId` parameter. You can use the `lookup_output` method to look up the value dynamically. Here's an example:

configs/demo/params/development.txt:

    VpcId=<%= lookup_output("vpc.VpcId") %>

The vpc stack's `VpcId` output us used as the `VpcId` parameter for the demo stack:

    lono cfn deploy demo # will use the VpcId parameter from `lookup_output`

{% include back_to/dsl-extras.md %}

{% include prev_next.md %}
