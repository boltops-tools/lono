module Lono
  class Blueprint < Command
    long_desc Help.text("blueprint/new")
    New.cli_options.each do |args|
      option(*args)
    end
    register(New, "new", "new NAME", "Generates new lono blueprint.")

    desc "list", "Lists project blueprints"
    long_desc Help.text("blueprint/new")
    def list
      List.available
    end

    desc "show", "show blueprint path"
    long_desc Help.text("blueprint/show")
    def show
      Show.new(options).run
    end
  end
end
