# Note: These are experimental helpers. Their interface may change or removed entirely.
module Lono::Template::Dsl::Builder::Helpers
  module ParamHelper
    # Creates:
    #
    #    1. parameter
    #    2. condition - used to make it optional
    #
    def conditional_parameter(name, options={})
      options = normalize_conditional_parameter_options(options)
      parameter(name, options)
      condition("Has#{name}", not!(equals(ref(name), "")))
    end

    # use long name to minimize method name collision
    def normalize_conditional_parameter_options(options)
      if options.is_a?(Hash)
        options = if options.empty?
          ""
        else
          defaults = { Default: "" }
          options.reverse_merge(defaults)
        end
      end

      options
    end

    def optional_ref(name)
      if!("Has#{name}", ref(name), ref("AWS::NoValue"))
    end
  end
end
