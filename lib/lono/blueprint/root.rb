require "bundler"

class Lono::Blueprint
  module Root
    # Switch the lono root
    def set_blueprint_root(blueprint)
      blueprint_root = find_blueprint_root(blueprint)
      if blueprint_root
        Lono.blueprint_root = blueprint_root
      else
        puts <<~EOL.color(:red)
          ERROR: Unable to find the blueprint #{blueprint.inspect}.
          Are you sure its in your Gemfile or in the blueprints folder with the correct name?
        EOL
        Lono::Finder::Blueprint.list
        ENV['LONO_TEST'] ? raise("Unable to find blueprint: #{blueprint.inspect}") : exit(1)
      end
    end

    def find_blueprint_root(blueprint)
      config = Lono::Finder::Blueprint.find(blueprint) # blueprint_root
      config.root if config
    end
  end
end
