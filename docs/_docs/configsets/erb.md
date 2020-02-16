---
title: Configset ERB
nav_text: ERB
categories: configsets
order: 4
nav_order: 26
---

Configsets can be written with ERB and YAML also.  Writing configsets with YAML can be useful for very simple configsets.

## Example

```yaml
AWS::CloudFormation::Init:
  config:
    packages:
      yum:
        httpd: []
    files:
      "/var/www/html/index.html":
        content: |
<%= indent(@html, 10) %>
    services:
      sysvinit:
       httpd:
        enabled: true
        ensureRunning: true
```

The `indent` method is a built-in helper for ERB. It aligns the text and is useful for YAML-based configsets.  The `@html` variable can be set by the author of the configset or overridden by you with [variables]({% link _docs/configsets/variables.md %}).

{% include prev_next.md %}
