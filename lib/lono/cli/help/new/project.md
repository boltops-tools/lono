## Example

    $ lono new project infra
    => Creating new project called infra.
          create  infra
          create  infra/.gitignore
          create  infra/Gemfile
          create  infra/README.md
          create  infra/config/app.rb
    => Initialize git repo
             run  git init from "."
    Initialized empty Git repository in /home/ec2-user/environment/infra/.git/
    => Installing dependencies with: bundle install
    Resolving dependencies...Fetching gem metadata from https://rubygems.org/.......
    ............................
    Using concurrent-ruby 1.1.9
    ...
    Bundle complete! 1 Gemfile dependency, 40 gems now installed.
    Use `bundle info [gemname]` to see where a bundled gem is installed.
    ================================================================
    Congrats 🎉 You have successfully created a lono project.

        cd infra

    To generate a new blueprint:

        lono new blueprint demo --examples

    To deploy:

        lono up demo

    More info: https://lono.cloud/
    $
