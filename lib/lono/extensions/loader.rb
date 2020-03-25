class Lono::Extensions
  module Loader
    include Lono::Template::Context::Loader::LoadFiles

    def load_all_extension_helpers
      Lono::Jade::Registry.tracked_extensions.each do |registry|
        load_extension_helpers(registry)
      end
    end

    def load_extension_helpers(registry)
      root = find_extensions_root_path(registry)
      extension_file = "#{root}/lib/#{registry.name}"
      require extension_file
      helpers_path = "#{root}/lib/#{registry.name}/helpers"
      load_files(helpers_path)
    end

    #
    #     1. vendor/extensions
    #     2. normal gem
    #     3. materialized gem
    #
    def find_extensions_root_path(registry)
      @finder ||= Lono::Finder::Extension.new
      jadespec = @finder.find(registry.name)
      jadespec.root
    end
  end
end
