module Lono::Inspector
  class Base
    delegate :required_parameters, :optional_parameters, :parameters, :data,
             to: :output_template

    extend Memoist
    include Lono::Blueprint::Root

    def initialize(blueprint, template, options)
      @blueprint, @template, @options = blueprint, template, options
    end

    def run
      blueprints = Lono::Blueprint::Find.one_or_all(@blueprint)
      blueprints.each do |blueprint|
        @blueprint = blueprint # intentional overwrite
        generate_templates
        set_blueprint_root(blueprint)
        templates = @template_name ? [@template_name] : all_templates
        templates.each do |template_name|
          perform(template_name)
        end
      end
    end

    def generate_templates
      Lono::Template::Generator.new(@blueprint, @options.clone.merge(quiet: false)).run
    end

    def all_templates
      templates_path = "#{Lono.config.output_path}/#{@blueprint}/templates"
      Dir.glob("#{templates_path}/**").map do |path|
        path.sub("#{templates_path}/", '').sub('.yml','') # template_name
      end
    end

    def output_template
      Lono::OutputTemplate.new(@blueprint, @template)
    end
    memoize :output_template
  end
end
