class Lono::Files::Builder
  class LambdaLayer < Lono::Files::Base
    def run
      layer = @options[:layer]
      return unless layer # triggers Lambda Layer building
      unless layer =~ /ruby/
        logger.warn "WARN: Currently only support Ruby lambda layers automatically".color(:yellow)
        return
      end

      klass_name = "Lono::Files::Builder::LambdaLayer::#{layer.camelize}Packager"
      klass = klass_name.constantize
      packager = klass.new(@options)
      packager.build
    end
  end
end
