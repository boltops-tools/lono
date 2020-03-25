class Lono::Finder::Blueprint
  class Configset < Lono::Finder::Configset
    def initialize(options={})
      super(**options) # **options to remove: warning: Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
      @blueprint_root = options[:blueprint_root] || Lono.blueprint_root
    end

    def local
      project + vendor + blueprint_app + gems
    end

    def blueprint_app
      roots = path_roots("#{@blueprint_root}/app/#{type.pluralize}")
      components(roots, "blueprint")
    end
  end
end
