module Lono::Markdown
  class Creator
    def self.create_all(command_class,  parent_command_name=nil)
      new(command_class, parent_command_name).create_all
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

          puts "Creating subcommands pages for #{parent_command_name}..."
          Creator.create_all(subcommand_class, parent_command_name)
        end
      end
    end

    def create_page(page)
      puts "Creating #{page.path}..."
      FileUtils.mkdir_p(File.dirname(page.path))
      IO.write(page.path, page.doc)
    end

    def create_index
      page = Index.new(@command_class)
      FileUtils.mkdir_p(File.dirname(page.path))
      puts "Creating #{page.path}"
      IO.write(page.path, page.doc)
    end

    def subcommand?(command_name)
      @command_class.subcommands.include?(command_name)
    end

    def subcommand_class(command_name)
      @command_class.subcommand_classes[command_name]
    end
  end
end
