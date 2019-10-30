---
title: Built-in Helpers
categories: dsl-components
nav_order: 33
---

Here are some of the built-in helpers available in the Lono DSL:

Method | Description
--- | ---
content | Returns the script from the `app/content` folder as a String. Meant for any general content.
tags | Converts a standard Ruby hash to the CloudFormation key, value structure.
user_data | Returns the script from the `app/user_data` folder as a String. Meant for user_data scripts.

The built-in helpers are defined in this this source code file: [dsl/builder/helper.rb](https://github.com/tongueroo/lono/blob/master/lib/lono/template/dsl/builder/helper.rb).

You can also create your own helpers with [Custom Helpers]({% link _docs/dsl/components/custom-helpers.md %}).

{% include prev_next.md %}
