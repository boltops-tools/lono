class Lono::Builder::Dsl
  class Evaluator < Lono::CLI::Base
    include Lono::Builder::Context::Loaders
    include Lono::Builder::Dsl::Syntax
    include Lono::Utils::Pretty

    def initialize(options={})
      super
      @template_path = "#{@blueprint.root}/template.rb"
      @parameters = [] # built by parameter_groups.rb
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

    # Example path: /full/path/to/project/app/blueprints/demo/template.rb
    def evaluate_template_paths(path)
      ext = File.extname(path)
      folder = path.sub(ext, '')
      expr = "#{folder}/**/*.rb"
      evaluate_template_path(path) # process top-level template.rb first
      Dir.glob(expr).each do |path|
        evaluate_template_path(path)
      end
    end

    def evaluate_template_path(path)
      return unless File.exist?(path)
      instance_eval(File.read(path), path)
    rescue Exception => e
      template_evaluation_error(e)
      exit 1
    end

    # Prints out a user friendly task_definition error message
    #
    # Backtrace lines are different for OSes:
    #
    #   windows: "C:/Ruby31-x64/lib/ruby/gems/3.1.0/gems/terraspace-1.1.1/lib/terraspace/builder.rb:34:in `build'"
    #   linux: "/home/ec2-user/.rvm/gems/ruby-3.0.3/gems/terraspace-1.1.1/lib/terraspace/compiler/dsl/syntax/mod.rb:4:in `<module:Mod>'"
    #
    def template_evaluation_error(e)
      lines = e.backtrace.reject { |l| l.include?("/lib/lono/") }
      error_info = lines.first
      parts = error_info.split(':')
      windows = error_info.match(/^[a-zA-Z]:/)
      path = windows ? parts[1] : parts[0]
      line_no = windows ? parts[2] : parts[1]
      line_no = line_no.to_i
      logger.debug e.message
      logger.error "Error evaluating #{pretty_path(path)}".color(:red)
      logger.error "Here's the line with the error:\n\n"

      contents = IO.read(path)
      content_lines = contents.split("\n")
      context = 5 # lines of context
      top, bottom = [line_no-context-1, 0].max, line_no+context-1
      spacing = content_lines.size.to_s.size
      content_lines[top..bottom].each_with_index do |line_content, index|
        line_number = top+index+1
        if line_number == line_no
          logger.printf("%#{spacing}d %s\n".color(:red), line_number, line_content)
        else
          logger.printf("%#{spacing}d %s\n", line_number, line_content)
        end
      end
    end
  end
end
