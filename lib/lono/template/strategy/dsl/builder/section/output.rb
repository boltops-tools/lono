# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
module Lono::Template::Strategy::Dsl::Builder::Section
  class Output < Base
    def template
      camelize(standarize(@definition))
    end

    # Value is the only required property: https://amzn.to/2xbhmk3
    def standarize(definition)
      first, second, _ = definition
      if definition.size == 1 && first.is_a?(Hash) # long form
        first # pass through
      elsif definition.size == 2 && second.is_a?(Hash) # medium form
        if second.key?(:value) || second.key?("Value")
          logical_id, properties = first, second
        else
          logical_id = first
          properties = {Value: second}
        end
        { logical_id => properties }
      elsif definition.size == 2 && (second.is_a?(String) || second.nil?) # short form
        logical_id = first
        properties = second.is_a?(String) ? { Value: second } : {}
        { logical_id => properties }
      elsif definition.size == 1
        logical_id = first.to_s
        properties = { Value: ref(logical_id) }
        { logical_id => properties }
      else # I dont know what form
        raise "Invalid form provided. definition #{definition.inspect}"
      end
    end
  end
end
