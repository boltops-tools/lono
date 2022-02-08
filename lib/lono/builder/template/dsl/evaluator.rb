class Lono::Builder::Template::Dsl
  class Evaluator
    include Lono::Extensions::Loader
    include Lono::Utils::Context
    include Lono::Builder::Context::Loader

    include Syntax
    extend Memoist

    def initialize(options={})
      @options = options
      @blueprint = Lono::Blueprint.new(options)
      @template_path = "#{@blueprint.root}/template.rb"
      @parameters = [] # registry
      @cfn = {}
    end

    def build
      # TODO: load_all_extension_helpers # after Extensions::Preparer#run
      load_variables unless seed? # both blueprint and project variables
      load_blueprint_helpers
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

    # Dont want any existing files to prevent building the blueprint.
    # This means that parameters cannot be based on vars. It's a trade-off.
    def seed?
      ARGV[0] == "seed"
    end
  end
end
