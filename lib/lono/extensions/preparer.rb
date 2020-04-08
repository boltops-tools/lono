class Lono::Extensions
  class Preparer < Lono::AbstractBase
    def initialize(options={})
      super
      @register = Register.new(options)
    end

    def run
      @register.run
      download
      final_materialize
    end

    def download
      Lono::Jade::Registry.tracked_extensions.each do |registry|
        jade = Lono::Jade.new(registry.name, "extension", registry)
        jade.materialize # adds to Lono::Jade::Registry.downloaded_extensions
      end
    end

    def final_materialize
      jades = Lono::Jade::Registry.downloaded_extensions
      Lono::Jade::Materializer::Final.new.build(jades)
    end
  end
end
