# Note: These are experimental helpers. Their interface may change or removed entirely.
module Lono::Template::Dsl::Builder::Helpers
  module ParamHelper
    # Decorate the parameter method to make smarter.
    def parameter(*definition)
      name, second, _ = definition
      # medium form
      if definition.size == 2 && second.is_a?(Hash) && second[:Conditional]
        # Creates:
        #
        #    1. parameter
        #    2. condition - used to make it optional
        #
        options = normalize_conditional_parameter_options(second)
        super(name, options)
        condition("Has#{name}", not!(equals(ref(name), "")))
      else
        super
      end
    end

    # use long name to minimize method name collision
    def normalize_conditional_parameter_options(options)
      if options.is_a?(Hash)
        options.delete(:Conditional)
        options = if options.empty?
          ""
        else
          defaults = { Default: "" }
          options.reverse_merge(defaults)
        end
      end

      options
    end

    # Creates:
    #
    #    1. parameter
    #    2. condition - used to make it optional
    #
    def conditional_parameter(name, options={})
      puts "DEPRECATED: Will be removed. Instead use: parameter(name, Conditional: true)"
      options = normalize_conditional_parameter_options(options)
      parameter(name, options)
      condition("Has#{name}", not!(equals(ref(name), "")))
    end

    def optional_ref(name)
      puts "DEPRECATED: Will be removed. Instead use: ref(name, Conditional: true)"
      if!("Has#{name}", ref(name), ref("AWS::NoValue"))
    end
  end
end
