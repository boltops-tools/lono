class Lono::Builder::Dsl::Syntax::Core::Resource
  # Moves the property to the top-level attributes *destructively*
  class PropertyMover
    def initialize(resource, logical_id, properties)
      @resource, @logical_id, @properties = resource, logical_id, properties
    end

    # AWS Docs: Resource attribute reference
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-product-attribute-reference.html
    def move!
      %w[
        Condition
        CreationPolicy
        DeletionPolicy
        DependsOn
        Metadata
        UpdatePolicy
        UpdateReplacePolicy
      ].each do |attribute_name|
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
