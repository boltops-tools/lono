---
title: service
nav_text: DSL
desc: You can use the services key to define which services should be enabled or disabled
  when the instance is launched. On Linux systems, this key is supported by using
  sysvinit. On Windows systems, it is supported by using the Windows service manager.
  The service method maps to the AWS::CloudFormation::Init [services](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html#aws-resource-init-services)
  seciton.
categories: configsets-dsl
order: 7
nav_order: 66
---

The `command` method maps to the [AWS::CloudFormation::Init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html) commands section.


```ruby
service("sysvinit",
  nginx: {
    enabled: true,
    ensureRunning: true,
    files: ["/etc/nginx/nginx.conf"],
    sources: ["/var/www/html"]
  },
  "php-fastcgi": {
    enabled: true,
    ensureRunning: true,
    packages: { yum: ["php", "spawn-fcgi"] }
  },
  sendmail: {
    enabled: false,
    ensureRunning: false
  }
)
```

Generates:

```yaml
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    services:
      sysvinit:
        nginx:
          enabled: true
          ensureRunning: true
          files:
          - "/etc/nginx/nginx.conf"
          sources:
          - "/var/www/html"
        php-fastcgi:
          enabled: true
          ensureRunning: true
          packages:
            yum:
            - php
            - spawn-fcgi
        sendmail:
          enabled: false
          ensureRunning: false
```

Back to [DSL Docs]({% link _docs/configsets/dsl.md %})

{% include prev_next.md %}
