# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
module Lono::Template::Strategy::Dsl::Builder::Section
  class Mapping < Base
    def template
      camelize(standarize(@definition))
    end

    # Type is the only required property: https://amzn.to/2x8W5aD
    def standarize(definition)
      first, second, _ = definition
      if definition.size == 1 && first.is_a?(Hash) # long form
        first # pass through
      elsif definition.size == 2 && second.is_a?(Hash) # medium form
        logical_id, maps = first, second
        { logical_id => maps }
      else # I dont know what form
        raise "Invalid form provided. definition #{definition.inspect}"
      end
    end
  end
end
