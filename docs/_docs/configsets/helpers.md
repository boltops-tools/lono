---
title: Configset Helpers
nav_text: Helpers
categories: configsets
order: 5
nav_order: 69
---

Helpers allow you to extend the Configset DSL.

## Example

Here's a simple example that will add a `yum` keyword.

lib/helpers/yum_helper.rb

```ruby
module YumHelper
  def yum(*packages)
    list = packages.inject({}) { |result, p| result.merge(p => []) }
    package("yum", list)
  end
end
```

Now you can use like so:

```ruby
yum("tree", "vim")
```

And it'll generate something like this:

```yaml
---
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    packages:
      yum:
        tree: []
        vim: []
```

Both ERB and DSL from supports adding your own custom helpers.

{% include prev_next.md %}
