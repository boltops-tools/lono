# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
class Lono::Template::Dsl::Builder
  class Resource < Base
    def template
      camelize(standarize(@definition))
    end

    # Type is the only required property: https://amzn.to/2x8W5aD
    def standarize(definition)
      first, second, third, _ = definition
      if definition.size == 1 && first.is_a?(Hash) # long form
        first # pass through
      elsif definition.size == 2 && second.is_a?(Hash) # medium form
        logical_id, attributes = first, second
        attributes.delete(:properties) if attributes[:properties].nil? || attributes[:properties].empty?
        { logical_id => attributes }
      elsif definition.size == 2 && second.is_a?(String) # short form with no properties
        logical_id, type = first, second
        { logical_id => {
            type: type
        }}
      elsif definition.size == 3 && (second.is_a?(String) || second.is_a?(NilClass)) # short form
        logical_id, type, properties = first, second, third
        resource = { logical_id => {
                       type: type
                    }}

        attributes = resource.values.first

        property_mover = PropertyMover.new(resource, logical_id, properties)
        property_mover.move!

        attributes[:properties] = properties unless properties.empty?
        resource
      else # Dont understand this form
        raise "Invalid form provided. definition #{definition.inspect}"
      end
    end
  end
end
