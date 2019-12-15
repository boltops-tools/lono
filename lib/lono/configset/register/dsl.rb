module Lono::Configset::Register
  module Dsl
    def configset(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      registry = Lono::Configset::Registry.new(args, options)
      self.class.append(registry)
      store_for_validation(registry)
    end

    # DSL
    def source(v)
      self.class.source = v
    end
  end
end
