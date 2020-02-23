class Lono::Extensions
  class Preparer < Lono::AbstractBase
    def initialize(options={})
      super
      @register = Register.new(options)
      @loader = Loader.new(options)
    end

    def run
      @register.run
      materialize
      # no need to validate because bundler will fail to install extension earlier and is a form of "validation already"
      @loader.run
    end

    def materialize
      Lono::Jade::Registry.tracked_extensions.each do |registry|
        jade = Lono::Jade.new(registry.name, "extension", registry)
        jade.materialize
      end
    end
  end
end
