class Lono::Template::Dsl::Builder::Resource
  # Moves the property to the top-level attributes *destructively*
  class PropertyMover
    def initialize(resource, logical_id, properties)
      @resource, @logical_id, @properties = resource, logical_id, properties
    end

    def move!
      %w[depends_on condition].each do |attribute_name|
        move(attribute_name.to_sym)
      end
    end

    def move(attribute_name)
      attribute_value = @properties.delete(attribute_name)
      @resource[@logical_id][attribute_name] = attribute_value if attribute_value
    end
  end
end
