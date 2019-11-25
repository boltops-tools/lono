class Lono::Template::Dsl::Builder
  class Base
    include Fn
    include Helper

    def initialize(blueprint, *definition)
      @blueprint = blueprint
      @definition = definition.flatten
    end

  private
    def camelize(attributes)
      blueprint_meta = Lono::Blueprint::Meta.new(@blueprint)
      target_section = self.class.to_s.split('::').last.underscore
      # target_section: Lono::Template::Dsl::Builder::Parameter => parameter
      if blueprint_meta.auto_camelize?(target_section)
        CfnCamelizer.transform(attributes)
      else
        stringify_keys!(attributes)
      end
    end

    # Accounts for Arrays also. ActiveSupport only works for Hashes.
    def stringify_keys!(data)
      case data
      when Array
        data.map! { |i| stringify_keys!(i) }
      when Hash
        data.deep_transform_keys! { |k| k.to_s }
      else
        data # do not transform
      end
    end
  end
end
