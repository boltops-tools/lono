class Lono::Template::Strategy::Dsl::Builder::Section::Resource
  # Moves the property to the top-level attributes *destructively*
  class PropertyMover
    def initialize(resource, logical_id, properties)
      @resource, @logical_id, @properties = resource, logical_id, properties
    end

    def move!
      %w[depends_on condition].each do |attribute_name|
        # Account for camelize, underscore, String, and Symbol
        move(attribute_name.to_sym)
        move(attribute_name.camelize.to_sym)
        move(attribute_name)
        move(attribute_name.camelize)
      end
    end

    def move(attribute_name)
      attribute_value = @properties.delete(attribute_name)
      @resource[@logical_id][attribute_name] = attribute_value if attribute_value
    end
  end
end
