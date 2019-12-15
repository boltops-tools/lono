module Lono::Template::Strategy::Dsl::Builder::Section
  class Base
    include Lono::Template::Strategy::Dsl::Builder::Fn
    include Lono::Template::Strategy::Dsl::Builder::Helpers
    include Lono::Template::Strategy::Dsl::Builder::Stringify

    def initialize(blueprint, *definition)
      @blueprint = blueprint
      @definition = definition.flatten
    end

  private
    def camelize(attributes)
      blueprint_meta = Lono::Blueprint::Meta.new(@blueprint)
      target_section = self.class.to_s.split('::').last.underscore
      # target_section: Lono::Template::Dsl::Builder::Parameter => parameter
      data = if blueprint_meta.auto_camelize?(target_section)
               CfnCamelizer.transform(attributes)
             else
               stringify!(attributes)
             end
      clean(data)
    end

    # Remove items with nil value automatically
    def clean(data)
      Lono::Template::Strategy::Dsl::Builder::Squeezer.new(data).squeeze
    end
  end
end
