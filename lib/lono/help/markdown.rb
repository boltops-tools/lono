require 'thor'

module Lono::Help
  # Override stdout as an @io object so we can pass the text of the written
  # output to the shell around.
  class Shell < Thor::Shell::Basic
    def stdout
      @io ||= StringIO.new
    end
  end

  class Markdown
    def initialize(cli_class, command_name)
      @cli_class = cli_class
      @command_name = command_name
      @command = @cli_class.commands[@command_name]
    end

    def usage
      banner = @cli_class.send(:banner, @command) # banner is protected method
      invoking_command = File.basename($0) # could be rspec, etc
      banner.sub(invoking_command, "lono")
    end

    # Use command's description as summary
    def summary
      @command.description
    end

    def options
      shell = Lono::Help::Shell.new
      Lono::CLI.send(:class_options_help, shell, nil => @command.options.values)
      text = shell.stdout.string
      text.split("\n")[1..-1].join("\n") # remove first line wihth "Options: "
    end

    # Use command's long description as many description
    def description
      text = @command.long_description
      lines = text.split("\n")
      lines.map do |line|
        # In the CLI help, we use 2 spaces to designate commands
        # In Markdown we need 4 spaces.
        line.sub(/^  \b/, '    ')
      end.join("\n")
    end
  end
end
