A quick way create a project configset is with the [lono configset new](/reference/include configsets/lono-configset-new.md/) command.  It will generate a skeleton configset structure in `app/configsets`.

    $ lono configset new httpd
    => Creating new configset called httpd.
          create  app/configsets/httpd
          create  app/configsets/httpd/httpd.gemspec
          create  app/configsets/httpd/.gitignore
          create  app/configsets/httpd/.rspec
          create  app/configsets/httpd/Gemfile
          create  app/configsets/httpd/README.md
          create  app/configsets/httpd/Rakefile
          create  app/configsets/httpd/lib/configset.rb
    $
