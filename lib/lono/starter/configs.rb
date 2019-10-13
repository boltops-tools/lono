class Lono::Starter
  class Configs
    include Lono::Blueprint::Root
    include Lono::Conventions

    def initialize(blueprint, options={})
      @blueprint, @options = blueprint, options
      set_blueprint_root(@blueprint)
      @template, @param = template_param_convention(options)
    end

    def create
      puts "Creating starter config files for #{@blueprint}"

    end
  end
end
