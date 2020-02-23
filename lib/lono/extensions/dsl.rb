class Lono::Extensions
  module Dsl
    def extend_with(*args, **options)
      register_extension_helper(args, options)
    end

    def register_extension_helper(args, options={})
      Lono::Jade::Registry.register_extension(args, options)
    end
  end
end
