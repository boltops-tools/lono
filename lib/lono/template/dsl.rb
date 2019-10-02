class Lono::Template
  class Dsl < Base
    attr_reader :results
    def initialize(blueprint, options={})
      super
    end

    def run
      puts "Generating CloudFormation templates for blueprint #{@blueprint.color(:green)}:" unless @options[:quiet]
      paths = Dir.glob("#{Lono.config.templates_path}/**/*.rb")
      paths.select{ |e| File.file?(e) }.each do |path|
        build_template(path)
      end
    end

    def build_template(path)
      builder = Builder.new(path, @blueprint, @options)
      builder.build
    end
  end
end
