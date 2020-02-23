module Lono::Template::Strategy
  class Dsl < Base
    attr_reader :results
    def run
      puts "Generating CloudFormation templates for blueprint #{@blueprint.color(:green)}:" unless @options[:quiet]
      build_template
    end

    def build_template
      builder = Builder.new(@options)
      builder.build
    end
  end
end
