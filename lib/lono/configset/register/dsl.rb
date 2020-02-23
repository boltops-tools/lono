module Lono::Configset::Register
  module Dsl
    def configset(*args, **options)
      registry = Lono::Jade::Registry.register_configset(args, options)
      self.class.append(registry)
      store_for_validation(registry)
    end

    # DSL
    def source(v)
      self.class.source = v
    end
  end
end
