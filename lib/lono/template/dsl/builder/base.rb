class Lono::Template::Dsl::Builder
  class Base
    include Fn
    include Helper

    def initialize(*definition)
      @definition = definition.flatten
    end

    def camelize(attributes)
      # CfnCamelizer.transform(attributes)
      attributes.deep_transform_keys! { |k| k.to_s }
    end
  end
end
