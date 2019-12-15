module Lono
  class Blueprint < Command
    long_desc Help.text("blueprint/new")
    New.cli_options.each do |args|
      option(*args)
    end
    register(New, "new", "new NAME", "Generates new lono blueprint.")

    desc "list", "Lists project blueprints"
    long_desc Help.text("blueprint/list")
    def list
      Finder::Blueprint.list
    end
  end
end
