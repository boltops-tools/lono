class Lono::AppFile::Build
  class LambdaLayer
    def initialize(blueprint, registry_item)
      @blueprint, @registry_item = blueprint, registry_item
    end

    def build
      lang = @registry_item.options[:lang]
      unless lang =~ /ruby/
        puts "WARN: Currently only support ruby lambda layers".color(:yellow)
        return
      end

      klass_name = "Lono::AppFile::Build::LambdaLayer::#{lang.camelize}Packager"
      klass = klass_name.constantize
      packager = klass.new(@blueprint, @registry_item)
      packager.build
    end
  end
end
