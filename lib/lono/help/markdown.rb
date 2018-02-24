require 'thor'

module Lono::Help
  # Override stdout as an @io object so we can grab the text written normally
  # outputted to the shell.
  class Shell < Thor::Shell::Basic
    def stdout
      @io ||= StringIO.new
    end
  end

  class MarkdownMaker
    def self.all(command_class)
      new(command_class).all
    end

    def initialize(command_class)
      @command_class = command_class
    end

    def all
      @command_class.commands.keys.each do |command_name|
        markdown = Markdown.new(@command_class, command_name)
        if markdown.subcommand?
          puts "subcommand: #{command_name}"
        else
          puts "regular: #{command_name}"
          puts "markdown.filename #{markdown.filename}"
        end
      end
    end

    def filename

    end
  end

  class Markdown
    def initialize(command_class, command_name)
      @command_class = command_class
      @command_name = command_name
      @command = @command_class.commands[@command_name]
    end

    def cli_name
      "lono"
    end

    def filename
      "_docs/#{cli_name}-#{@command_name}.md"
    end

    def subcommand?
      @command_class.subcommands.include?(@command_name)
    end

    def usage
      banner = @command_class.send(:banner, @command) # banner is protected method
      invoking_command = File.basename($0) # could be rspec, etc
      banner.sub(invoking_command, cli_name)
    end

    # Use command's description as summary
    def summary
      @command.description
    end

    def options
      shell = Lono::Help::Shell.new
      Lono::CLI.send(:class_options_help, shell, nil => @command.options.values)
      text = shell.stdout.string
      lines = text.split("\n")[1..-1] # remove first line wihth "Options: "
      lines.map! do |line|
        # remove 2 leading spaces
        line.sub(/^  /, '')
      end
      lines.join("\n")
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

    def doc
      <<-EOL
---
title: #{usage}
---

## Usage

    #{usage}

## Summary

#{summary}

## Options

```
#{options}
```

## Description

#{description}
EOL
    end

  end
end
