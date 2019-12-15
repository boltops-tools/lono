class Lono::Template::Strategy::Dsl
  class Builder
    include Lono::Template::Util
    include Lono::Template::Context::Loader

    include Syntax
    extend Memoist

    def initialize(path, blueprint, options={})
      @path, @blueprint, @options = path, blueprint, options
      @template = @path.sub("#{Lono.config.templates_path}/",'').sub(/\.rb$/,'')
      @parameters = [] # registry
      @cfn = {}
    end

    def build
      load_context
      evaluate_template_path(@path) # modifies @cfn
      finalize
      to_yaml
      write_output
      @cfn
    end

    def finalize
      o = @options.merge(parameters: @parameters)
      @cfn = Finalizer.new(@cfn, o).run
    end

    def to_yaml
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

    # Not using Lono::Template::Context because that works differently.
    # That is used to load a context object that is passed to RenderMePretty's context.
    # So that we can load context for params files and erb templates.
    #
    # In this case builder is actually the dsl context.
    # We want to load variables and helpers into this builder context directly.
    # This loads additional context. It looks very similar to Lono::Template::Context
    def load_context
      load_variables
      load_project_helpers
    end
  end
end
