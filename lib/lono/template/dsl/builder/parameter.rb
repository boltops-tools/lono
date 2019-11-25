# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
class Lono::Template::Dsl::Builder
  class Parameter < Base
    def template
      add_required(standarize(@definition))
    end

    # Type is the only required property: https://amzn.to/2x8W5aD
    def standarize(definition)
      first, second, _ = definition
      if definition.size == 1 && first.is_a?(Hash) # long form
        first # pass through
      elsif definition.size == 2 && second.is_a?(Hash) # medium form
        logical_id, properties = first, second
        { logical_id => properties }
      elsif (definition.size == 2 && valid_value?(second)) || # short form
            definition.size == 1
        logical_id = first
        properties = valid_value?(second) ? { Default: second } : {}
        { logical_id => properties }
      else # I dont know what form
        raise "Invalid form provided. definition #{definition.inspect}"
      end
    end

    def add_required(attributes)
      properties = attributes.values.first
      properties["Type"] ||= 'String'
      attributes
    end

    def valid_value?(o)
      o.is_a?(Float) || o.is_a?(Integer) || o.is_a?(String) || o.is_a?(TrueClass) || o.is_a?(FalseClass)
    end
  end
end
