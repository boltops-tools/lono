---
title: Built-in Helpers
categories: dsl-components
nav_order: 34
---

Here are some of the built-in helpers available in the Lono DSL:

Method | Description
--- | ---
content | Returns the script from the `app/content` folder as a String. Meant for any general content.
[tags]({% link _docs/helpers/tags.md %}) | Converts a standard Ruby hash to the CloudFormation key, value structure.
user_data | Returns the script from the `app/user_data` folder as a String. Meant for user_data scripts.
[user_data_script]({% link _docs/helpers/user_data_script.md %}) | Path location of the script to be used along with the `user_data_script` helper.

The built-in helpers are defined in this this source code file: [dsl/builder/helpers/core_helper.rb](https://github.com/tongueroo/lono/blob/master/lib/lono/template/dsl/builder/helpers/core_helper.rb).

You can also create your own helpers with [Custom Helpers]({% link _docs/dsl/components/custom-helpers.md %}).

{% include prev_next.md %}
