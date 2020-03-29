---
title: Built-in Helpers
categories: dsl-components
nav_order: 24
---

Here are some of the built-in helpers available in the Lono DSL:

Method | Description
--- | ---
content | Returns the script from the `app/content` folder as a String. Meant for any general content.
default_subnets | Returns Array of default Subnet Ids. Useful for config params.
default_vpc | Returns default VPC id. Useful for config params.
extract_scripts | Generates a script that can be included in user_data scripts to extract `app/script` files. More info about the helper is in the [App Scripts docs]({% link _docs/extras/app-scripts.md %}).
key_pairs | Returns Array of Key Pairs. You can pass it a pattern to filter for keypairs. IE: `key_pairs(/default/).first`. Useful for config params.
[tags]({% link _docs/helpers/tags.md %}) | Converts a standard Ruby hash to the CloudFormation key, value structure.
user_data | Returns the script from the `app/user_data` folder as a String. Meant for user_data scripts.
[user_data_script]({% link _docs/helpers/user_data_script.md %}) | Path location of the script to be used along with the `user_data_script` helper.

The built-in helpers are defined in this this source code file: [dsl/builder/helpers/core_helper.rb](https://github.com/tongueroo/lono/tree/master/lib/lono/template/strategy/dsl/builder/helpers).

You can also create your own helpers with [Custom Helpers]({% link _docs/dsl/components/custom-helpers.md %}).

{% include prev_next.md %}
