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
    def self.make_all(command_class)
      new(command_class).make_all
    end

    def initialize(command_class)
      @command_class = command_class
    end

    def make_all
      create_index

      @command_class.commands.keys.each do |command_name|
        markdown = Markdown.new(@command_class, command_name)
        create(markdown)
        # if markdown.subcommand?
        #   puts "subcommand: #{command_name}"
        # else
        #   puts "regular: #{command_name}"
        #   puts "markdown.filename #{markdown.filename}"
        # end
      end
    end

    def create_index
      page = MarkdownIndex.new(@command_class)
      FileUtils.mkdir_p(File.dirname(page.path))
      puts "Creating #{page.path}"
      IO.write(page.path, page.doc)
    end

    def create(markdown)
      puts "Creating #{markdown.path}..."
      FileUtils.mkdir_p(File.dirname(markdown.path))
      IO.write(markdown.path, markdown.doc)
    end
  end

  class MarkdownIndex
    def initialize(command_class)
      @command_class = command_class
    end

    def command_list
      @command_class.commands.keys.sort.map.each do |command_name|
        page = Markdown.new(@command_class, command_name)
        link = page.path.sub("docs/", "")
        # Example: [lono cfn]({% link _reference/lono-cfn.md %})
        "* [lono #{command_name}]({% link #{link} %})"
      end.join("\n")
    end

    def path
      "docs/reference.md"
    end

    def doc
      <<-EOL
---
title: Lono Reference
---

#{command_list}
EOL
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

    def path
      "docs/_reference/#{cli_name}-#{@command_name}.md"
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
      return "" if text.empty? # there are no options

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
      return "" if text.nil? # empty description

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
#{options_doc}
#{desc_doc}
EOL
    end

    # handles blank options
    def options_doc
      return '' if options.empty?

      <<-EOL
## Options

```
#{options}
```
EOL
    end

    # handles blank description
    def desc_doc
      return '' if description.empty?

      <<-EOL
## Description

#{description}
EOL
    end

  end
end
