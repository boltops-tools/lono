class Lono::Template::Strategy::Dsl
  class Builder
    include Lono::Template::Util
    include Lono::Template::Context::Loader
    include Lono::Extensions::Loader

    include Syntax
    extend Memoist

    def initialize(options={})
      @options = options
      @stack, @blueprint, @template, @param = Lono::Conventions.new(options).values
      @template_path = "#{Lono.config.templates_path}/#{@template}.rb"
      @parameters = [] # registry
      @cfn = {}
    end

    def build
      load_extensions # load_extensions before project helpers
      load_context # variables and project helpers
      evaluate_template_path(@template_path) # modifies @cfn
      finalize
      to_yaml
      write_output
      @cfn
    end

    # load_extensions and evaluate extend_with methods earlier than load_context so project helpers can override extensions
    def load_extensions # evaluates extend_with
      Lono::Extensions::Preparer.new(@options).run
      load_all_extension_helpers # after Extensions::Preparer#run
    end

    def finalize
      o = @options.merge(parameters: @parameters)
      @cfn = Finalizer.new(@cfn, o).run
    end

    def to_yaml
      # https://stackoverflow.com/questions/24508364/how-to-emit-yaml-in-ruby-expanding-aliases
      # Trick to prevent YAML from emitting aliases
      @cfn = YAML.load(@cfn.to_json)
      @results = YAML.dump(@cfn)
    end

    def write_output
      path = "#{Lono.config.output_path}/#{@blueprint}/templates/#{@template}.yml"
      ensure_parent_dir(path)
      IO.write(path, @results)

      Lono::Yamler::Validator.new(path).validate!

      unless @options[:quiet]
        pretty_path = path.sub("#{Lono.root}/",'')
        puts "  #{pretty_path}"
      end
    end
  end
end
