require "active_support/core_ext/object"

module Lono::Markdown
  class Creator
    cattr_accessor :mute

    def self.create_all(command_class,  parent_command_name=nil)
      clean unless parent_command_name
      new(command_class, parent_command_name).create_all
    end

    def self.clean
      FileUtils.rm_rf("docs/_reference")
      FileUtils.rm_rf("docs/reference.md")
    end

    # command_class is top-level CLI class.
    def initialize(command_class, parent_command_name)
      @command_class = command_class
      @parent_command_name = parent_command_name
    end

    def create_all
      create_index unless @parent_command_name

      @command_class.commands.keys.each do |command_name|
        page = Page.new(@command_class, command_name, @parent_command_name)
        create_page(page)

        if subcommand?(command_name)
          subcommand_class = subcommand_class(command_name)
          parent_command_name = command_name

          say "Creating subcommands pages for #{parent_command_name}..."
          Creator.create_all(subcommand_class, parent_command_name)
        end
      end
    end

    def create_page(page)
      say "Creating #{page.path}..."
      FileUtils.mkdir_p(File.dirname(page.path))
      IO.write(page.path, page.doc)
    end

    def create_index
      page = Index.new(@command_class)
      FileUtils.mkdir_p(File.dirname(page.path))
      say "Creating #{page.path}"
      IO.write(page.path, page.doc)
    end

    def subcommand?(command_name)
      @command_class.subcommands.include?(command_name)
    end

    def subcommand_class(command_name)
      @command_class.subcommand_classes[command_name]
    end

    def say(text)
      puts text unless self.class.mute
    end
  end
end
