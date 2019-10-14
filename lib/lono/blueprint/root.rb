require "bundler"

class Lono::Blueprint
  module Root
    # Switch the lono root
    # TODO: account multimode or only have multimode?
    # TODO: switch to gem path
    def set_blueprint_root(blueprint)
      # puts "blueprint #{blueprint}"
      # puts caller[0..2]

      blueprint_root = find_blueprint_root(blueprint)
      if blueprint_root
        Lono.blueprint_root = blueprint_root
      else
        puts <<~EOL.color(:red)
          ERROR: Unable to find the blueprint #{blueprint}.
          Are you sure its in your Gemfile or in the blueprints folder
          with the correct blueprint_name in .meta/config.yml?
        EOL
        List.available
        exit 1
      end
    end

    def find_blueprint_root(blueprint)
      require_bundle_gems # ensures that gem will be found so we can switch to it

      Find.find(blueprint) # blueprint_root
    end

    def bundler_groups
      [:default, Lono.env.to_sym]
    end

    def require_bundle_gems
      # NOTE: Dont think ENV['BUNDLE_GEMFILE'] is quite working right.  We still need
      # to be in the project directory.  Leaving logic in here for when it gets fix.
      if ENV['BUNDLE_GEMFILE'] || File.exist?("Gemfile")
        require "bundler/setup"
        Bundler.require(*bundler_groups)
      end
    end
  end
end
