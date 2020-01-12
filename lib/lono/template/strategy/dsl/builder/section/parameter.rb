# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
module Lono::Template::Strategy::Dsl::Builder::Section
  class Parameter < Base
    attr_accessor :group_label
    attr_reader :conditional, :label

    def template
      camelize(add_required(track_label(track_conditional(standarize(@definition)))))
    end

    # Type is the only required property: https://amzn.to/2x8W5aD
    def standarize(definition)
      first, second, third = definition
      if definition.size == 1 && first.is_a?(Hash) # long form
        first # pass through
      elsif definition.size == 2 && second.is_a?(Hash) # medium form - 1
        logical_id, properties = first, second
        { logical_id => properties }
      elsif definition.size == 3 && !second.is_a?(Hash) && third.is_a?(Hash) # medium form variant - 2
        third[:Default] = second # probably a String, Integer, or Float
        logical_id, properties = first, third
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

    def track_conditional(attributes)
      properties = attributes.values.first
      @conditional ||= properties[:Conditional] # flag for later
      properties.delete(:Conditional) # remove property, it's not a real property, used to flag conditional parameters
      # Ensure default
      if @conditional
        defaults = { Default: "" }
        properties.reverse_merge!(defaults)
      end
      attributes
    end

    def track_label(attributes)
      properties = attributes.values.first
      @label ||= properties[:Label] # flag for later
      properties.delete(:Label) # remove property, it's not a real property, used to build metadata interface
      attributes
    end

    def name
      template.keys.first # logical_id or name
    end
  end
end
