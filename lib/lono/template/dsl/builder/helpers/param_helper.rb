# Note: These are experimental helpers. Their interface may change or removed entirely.
module Lono::Template::Dsl::Builder::Helpers
  module ParamHelper
    # Creates:
    #
    #    1. parameter
    #    2. condition - used to make it optional
    #
    def conditional_parameter(name, options={})
      if options.empty?
        options = ""
      else
        defaults = { Default: "" }
        options.reverse_merge!(defaults)
      end

      parameter(name, options)
      condition("Has#{name}", not!(equals(ref(name), "")))
    end

    def optional_ref(name)
      if!("Has#{name}", ref(name), ref("AWS::NoValue"))
    end
  end
end
