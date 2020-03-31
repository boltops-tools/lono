## Configset Example

Here's a simple configset example in [DSL form]({% link _docs/configsets/dsl.md %}).

app/configsets/httpd/lib/configset.rb:

```ruby
package("yum",
  httpd: []
)
file("/var/www/html/index.html",
  content: "<h2>html test content</h2>"
)
service("sysvinit",
  httpd: {
    enabled: true,
    ensureRunning: true,
  }
)
```

The configet can also be written in [ERB form]({% link _docs/configsets/erb.md %}).

app/configsets/httpd/lib/configset.yml:

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
          enabled: true
          ensureRunning: true
```

This configset will install, configure, and ensure that the httpd server is running, even if the server is rebooted.
