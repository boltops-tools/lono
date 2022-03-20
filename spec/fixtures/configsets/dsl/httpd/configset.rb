package("yum",
  httpd: []
)
file("/var/www/html/index.html",
  content: "<h1>headline</h1>"
)
service("sysvinit",
  httpd: {
    enabled: true,
    ensureRunning: true,
  }
)
