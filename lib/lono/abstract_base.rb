module Lono
  class AbstractBase
    extend Memoist
    include Lono::Blueprint::Root

    def initialize(options={})
      reinitialize(options)
    end

    # Hack so that we can use include Thor::Base
    def reinitialize(options)
      @options = options
      Lono::ProjectChecker.check
      @stack, @blueprint, @template, @param = Conventions.new(options).values

      return if options[:source]
      set_blueprint_root(@blueprint)
      Lono::ProjectChecker.empty_templates
    end

    def template_path
      "#{Lono.config.output_path}/#{@blueprint}/templates/#{@template}.yml"
    end
  end
end
