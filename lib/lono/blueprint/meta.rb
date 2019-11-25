require "yaml"

class Lono::Blueprint
  class Meta
    extend Memoist

    def initialize(blueprint)
      @blueprint = blueprint
    end

    def data
      blueprint_location = Find.find(@blueprint)
      meta_config = "#{blueprint_location}/.meta/config.yml"
      YAML.load_file(meta_config)
    end
    memoize :data

    %w[blueprint_name template_type].each do |meth|
      define_method meth do
        data[meth]
      end
    end

    def auto_camelize
      data['auto_camelize'].nil? || # for backward compatibility
      data['auto_camelize']
    end
  end
end
