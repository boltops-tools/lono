module Lono::Bundler
  class CLI < Lono::Command
    desc "bundle SUBCOMMAND", "bundle subcommands"
    long_desc Help.text(:bundle)
    subcommand "bundle", Bundle
  end
end
