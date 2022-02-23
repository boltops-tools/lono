module Lono::Builder::Configset::Definition::Dsl::Syntax
  module Package
    # In recent versions of the AmazonLinux2 cfnbootstrap, , the package command doesnt work with updated versions of rubygems.
    # Get this error
    #
    #    invalid option: --no-ri
    #
    # More details: https://gist.github.com/tongueroo/569878afdc7eb904490b9ee8b03f304f
    #
    # Found the cfnbootstrap version by looking at the source on 2020-03-21 in
    #
    #     $ cat /usr/lib/python2.7/site-packages/cfnbootstrap/public_constants.py
    #     _release = '31'
    #     _version = '1.4-' + _release
    #
    # There is no way to get the version from the /opt/aws/bin/cfn-init command.
    #
    # We work around this be using the command instruction and use the gem install and list commands.
    #
    #    $ gem list tilt -e -i -v 1.4.0
    #    false # also $? is 1
    #    $ gem list tilt -e -i -v 1.4.1
    #    true # also $? is 0
    #    $
    #
    def gem_package(name, version=nil)
      unless_clause = "gem list #{name} -e -i "
      unless_clause += "-v #{version}" if version
      command("#{name}-gem-install",
        command: "gem install #{name} #{version}",
        unless: unless_clause
      )
    end

    def yum_package(name, version=nil)
      versions = [version].compact
      package("yum", name => versions)
    end
  end
end
