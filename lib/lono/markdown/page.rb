module Lono::Markdown
  class Page
    def initialize(command_class, command_name, parent_command_name=nil)
      @command_class = command_class
      @command_name = command_name
      @parent_command_name = parent_command_name
      @command = @command_class.commands[@command_name]
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
      shell = Shell.new
      @command_class.send(:class_options_help, shell, nil => @command.options.values)
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

    def cli_name
      "lono"
    end

    def path
      full_name = if @parent_command_name
        "#{cli_name}-#{@parent_command_name}-#{@command_name}"
      else
        "#{cli_name}-#{@command_name}"
      end
      "docs/_reference/#{full_name}.md"
    end

    def subcommand?
      @command_class.subcommands.include?(@command_name)
    end

    def subcommand_class
      @command_class.subcommand_classes[@command_name]
    end

    # Note:
    # printable_commands are in the form:
    #  [
    #    [command_form,command_comment],
    #    [command_form,command_comment],
    #  ]
    #
    # It is useful to grab the command form printable_commands as it shows
    # the proper form.
    def subcommand_list
      return '' unless subcommand?

      invoking_command = File.basename($0) # could be rspec, etc
      command_list = subcommand_class.printable_commands
        .map { |a| a[0].sub!(invoking_command, cli_name); a } # replace with proper comand
        .reject { |a| a[0].include?("help [COMMAND]") } # filter out help

      # dress up with markdown
      text = command_list.map do |a|
        command, comment = a[0], a[1].sub(/^# /,'')
        subcommand_name = command.split(' ')[2]
        full_command_path = "#{cli_name}-#{@command_name}-#{subcommand_name}"
        full_command_name = "#{cli_name} #{@command_name} #{subcommand_name}"
        link = "_reference/#{full_command_path}.md"

        # "* [#{command}]({% link #{link} %})"
        # Example: [lono cfn delete STACK]({% link _reference/lono-cfn-delete.md %})
        "* [#{full_command_name}]({% link #{link} %}) - #{comment}"
      end.join("\n")

      <<-EOL
## Subcommands

#{text}
EOL
    end

    def doc
      <<-EOL
#{front_matter}
#{usage_markdown}
#{summary_markdown}
#{desc_markdown}
#{subcommand_list}
#{options_markdown}
EOL
    end

    def front_matter
      command = [cli_name, @parent_command_name, @command_name].compact.join(' ')
      <<-EOL
---
title: #{command}
reference: true
---
EOL
    end

    def usage_markdown
      <<-EOL
## Usage

    #{usage}
EOL
    end

    def summary_markdown
      <<-EOL
## Summary

#{summary}
EOL
    end

    # handles blank description
    def desc_markdown
      return '' if description.empty?

      <<-EOL
## Description

#{description}
EOL
    end

    # handles blank options
    def options_markdown
      return '' if options.empty?

      <<-EOL
## Options

```
#{options}
```
EOL
    end

  end
end
