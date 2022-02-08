class Lono::AppFile::Build
  class LambdaLayer
    def initialize(blueprint, registry_item)
      @blueprint.name, @registry_item = blueprint, registry_item
    end

    def build
      lang = @registry_item.options[:lang]
      unless lang =~ /ruby/
        logger.info "WARN: Currently only support ruby lambda layers".color(:yellow)
        return
      end

      klass_name = "Lono::AppFile::Build::LambdaLayer::#{lang.camelize}Packager"
      klass = klass_name.constantize
      packager = klass.new(@blueprint.name, @registry_item)
      packager.build
    end
  end
end
