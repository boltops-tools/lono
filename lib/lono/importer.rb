module Lono
  class Importer
    def initialize(options)
      @options = options

      Lono::ProjectChecker.check
      @blueprint = Lono::Conventions.new(options).blueprint
      # Dont use set_blueprint_root because it doesnt exist yet. The import creates it
      Lono.blueprint_root = "#{Lono.root}/app/blueprints/#{@blueprint}"
    end

    def run
      # Examples:
      #   Lono::Importer::Erb.new(source, options.clone).run
      #   Lono::Importer::Dsl.new(source, options.clone).run
      type = @options[:type] || 'dsl'
      importer_class = "Lono::Importer::#{type.classify}"
      importer_class = Object.const_get(importer_class)
      importer_class.new(@options).run
    end
  end
end
