class Lono::Extensions
  class Preparer < Lono::AbstractBase
    def initialize(options={})
      super
      @register = Register.new(options)
    end

    def run
      @register.run
      materialize
      # loading happens in Lono::Extensions::Loader load_all_extension_helpers module
      # so it has the proper self.class include scope
    end

    def materialize
      Lono::Jade::Registry.tracked_extensions.each do |registry|
        jade = Lono::Jade.new(registry.name, "extension", registry)
        jade.materialize
      end
    end
  end
end
