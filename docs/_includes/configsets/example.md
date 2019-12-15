## Configset Example

Here's an simple configset example:

```yaml
AWS::CloudFormation::Init:
  config:
    packages:
      yum:
        httpd: []
    files:
      "/var/www/html/index.html":
        content: "<h2>html test content</h2>"
    services:
      sysvinit:
       httpd:
        enabled: 'true'
        ensureRunning: 'true'
```

This configset will install, configure, and ensure that the httpd server is running, even if the server is rebooted.
