module Lono::Blueprint::Configset
  class Loader < Lono::Configset::Loader
    def finder_class
      Lono::Finder::Blueprint::Configset
    end
  end
end
