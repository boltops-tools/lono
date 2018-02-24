module Lono::Markdown
  class Creator
    def self.create_all(command_class)
      new(command_class).create_all
    end

    def initialize(command_class)
      @command_class = command_class
    end

    def create_all
      create_index

      @command_class.commands.keys.each do |command_name|
        page = Page.new(@command_class, command_name)
        create_page(page)
      end
    end

    def create_page(markdown)
      puts "Creating #{markdown.path}..."
      FileUtils.mkdir_p(File.dirname(markdown.path))
      IO.write(markdown.path, markdown.doc)
    end

    def create_index
      page = Index.new(@command_class)
      FileUtils.mkdir_p(File.dirname(page.path))
      puts "Creating #{page.path}"
      IO.write(page.path, page.doc)
    end
  end
end
