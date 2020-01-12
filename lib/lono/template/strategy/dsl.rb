module Lono::Template::Strategy
  class Dsl < Base
    attr_reader :results
    def initialize(options={})
      super
    end

    def run
      puts "Generating CloudFormation templates for blueprint #{@blueprint.color(:green)}:" unless @options[:quiet]
      template_path = "#{Lono.config.templates_path}/#{@template}.rb"
      build_template(template_path)
    end

    def build_template(path)
      builder = Builder.new(path, @blueprint, @options)
      builder.build
    end
  end
end
