require "fileutils"
require "memoist"
require "yaml"

# Subclasses should implement:
#
#   variables - Returns String with content of varibles files.
#   setup - Hook to do extra things like create IAM service roles.
#   finish - Finish hook after config files have been created.
#
# Note there is no params method to hook. The Base class handles params well.
#
class Lono::Seed
  class Base
    include Lono::AwsServices
    include Lono::Conventions
    extend Memoist

    def initialize(blueprint, options)
      @blueprint, @options = blueprint, options
      @template, @param = template_param_convention(options)
    end

    def run
      check_dsl_type!
      setup
      create_params
      create_variables
      finish
    end

    # Always create params files
    def create_params
      with_each_template do |path|
        create_param_file(path)
      end
    end

    def create_variables
      return unless variables
      dest_path = "configs/#{@blueprint}/variables/#{Lono.env}.rb"
      write(dest_path, variables)
      puts "Starter variables created: #{dest_path}"
    end

    def check_dsl_type!
      # TODO: only support DSL type right now
    end

    def setup; end
    def finish; end

    # meant to be overriden by subclass
    def variables
      <<~EOL
      # This is an empty starter variables file.
      # Please refer to the blueprint's README for variables to set.
      # Note some blueprints may not use variables.
      EOL
    end

    def create_param_file(app_template_path)
      parameters = parameters(app_template_path)

      lines = []
      lines << "# Required parameters:"
      required(parameters).each do |name, data|
        example = description_example(data["Description"])
        lines << "#{name}=#{example}"
      end
      lines << "# Optional parameters:"
      optional(parameters).each do |name, data|
        lines << "# #{name}=#{data["Default"]}"
      end
      content = lines.join("\n") + "\n"

      dest_path = "configs/#{@blueprint}/params/#{Lono.env}.txt" # only support environment level parameters for now
      write(dest_path, content)
      puts "Starter params created:    #{dest_path}"
    end

    def write(path, content)
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, content)
    end

    def description_example(description)
      default = '...'
      return default unless description
      md = description.match(/(Example|IE): (.*)/)
      return default unless md
      md[2]
    end

    def parameters(app_template_path)
      builder = Lono::Template::Dsl::Builder.new(app_template_path, @blueprint, quiet: false)
      template = builder.template
      template["Parameters"]
    end

    def required(parameters)
      parameters.reject { |logical_id, p| p["Default"] }
    end

    def optional(parameters)
      parameters.select { |logical_id, p| p["Default"] }
    end

  private
    def with_each_template
      paths = Dir.glob("#{Lono.config.templates_path}/**/*.rb")
      files = paths.select{ |e| File.file?(e) }
      files.each do |path|
        yield(path)
      end
    end
  end
end