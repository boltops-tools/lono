class Lono::Bundler::CLI
  class Bundle < Lono::Command
    lonofile_option = Proc.new {
      option :lonofile, default: ENV['LONOFILE'] || "Lonofile", desc: "Lonofile to use"
    }

    desc "list", "List bundled blueprints included by Lonofile"
    long_desc Help.text("bundle/list")
    lonofile_option.call
    def list
      Lono::Bundler::List.new(options).run
    end

    desc "info COMPONENT", "Provide info about a bundled component"
    long_desc Help.text("bundle/info")
    lonofile_option.call
    option :type, aliases: :t, desc: "Type. IE: blueprint, configset, extension"
    def info(component)
      Lono::Bundler::Info.new(options.merge(component: component)).run
    end

    desc "install", "Install blueprints from the Lonofile"
    long_desc Help.text("bundle/install")
    lonofile_option.call
    def install
      Lono::Bundler::Runner.new(options).run
    end

    desc "clean", "Clean cache"
    long_desc Help.text("bundle/clean")
    option :yes, aliases: :y, type: :boolean, desc: "bypass are you sure prompt"
    def clean
      Clean.new(options).run
    end

    desc "update [COMPONENT]", "Update bundled blueprints"
    long_desc Help.text("bundle/update")
    lonofile_option.call
    def update(*components)
      Lono::Bundler.update_mode = true
      Lono::Bundler::Runner.new(options.merge(components: components)).run
    end
  end
end
