class Lono::Finder::Blueprint
  class Configset < Lono::Finder::Configset
    def initialize(options={})
      super
      @blueprint_root = options[:blueprint_root] || Lono.blueprint_root
    end

    def local
      blueprint + vendor + gems
    end

    def blueprint
      roots = path_roots("#{@blueprint_root}/app/#{type.pluralize}")
      components(roots, "blueprint")
    end
  end
end
