class Lono::Extensions
  module Loader
    include Lono::Builder::Context::Loader::LoadFiles

    def load_all_extension_helpers
    end

    def load_extension_helpers(registry)
    end

    #
    #     1. vendor/extensions
    #     2. normal gem
    #     3. materialized gem
    #
    def find_extensions_root_path(registry)
    end
  end
end
