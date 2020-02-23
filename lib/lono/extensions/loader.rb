class Lono::Extensions
  class Loader < Lono::AbstractBase
    include Lono::Template::Context::Loader::LoadFiles

    def run
      Lono::Jade::Registry.tracked_extensions.each do |registry|
        load_extension_helpers(registry)
      end
    end

    def load_extension_helpers(registry)
      root = find_root(registry)
      helpers_path = "#{root}/lib/#{registry.name}/helpers"
      load_files(helpers_path)
    end

    #
    #     1. vendor/extensions
    #     2. normal gem
    #     3. materialized gem
    #
    def find_root(registry)
      jadespec = finder.find(registry.name)
      jadespec.root
    end

    def finder
      Lono::Finder::Extension.new
    end
    memoize :finder
  end
end
