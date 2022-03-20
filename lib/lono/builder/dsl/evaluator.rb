class Lono::Builder::Dsl
  class Evaluator < Lono::CLI::Base
    include DslEvaluator
    include Lono::Builder::Context
    include Lono::Builder::Dsl::Syntax
    include Lono::Utils::Pretty

    def initialize(options={})
      super
      @template_path = "#{@blueprint.root}/template.rb"
      @parameters = [] # built by parameter_groups.rb
      @cfn = {}
    end

    def evaluate
      load_context
      evaluate_template_paths(@template_path) # modifies @cfn
      finalize
      to_yaml
      @cfn
    end

    def finalize
      o = @options.merge(parameters: @parameters)
      @cfn = Finalizer.new(@cfn, o).run
    end

    def to_yaml
      # https://stackoverflow.com/questions/24508364/how-to-emit-yaml-in-ruby-expanding-aliases
      # Trick to prevent YAML from emitting aliases
      @cfn = YAML.load(@cfn.to_json)
    end

    # Example path: /full/path/to/project/app/blueprints/demo/template.rb
    def evaluate_template_paths(path)
      ext = File.extname(path)
      folder = path.sub(ext, '')
      expr = "#{folder}/**/*.rb"
      evaluate_file(path) # process top-level template.rb first
      Dir.glob(expr).each do |path|
        evaluate_file(path)
      end
    end
  end
end
