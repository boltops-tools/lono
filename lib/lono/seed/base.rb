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
    include Lono::Blueprint::Root
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
      dsl_type = template_type == 'dsl'
      unless dsl_type
        puts "Detected template_type: #{template_type}"
        puts "lono seed only supports dsl template types currently."
        exit 1
      end
    end

    def template_type
      blueprint_root = find_blueprint_root(@blueprint)
      meta_config = "#{blueprint_root}/.meta/config.yml"
      return false unless File.exist?(meta_config)

      meta = YAML.load_file(meta_config)
      meta['template_type']
    end

    def setup; end
    def finish; end

    # Meant to be overriden by subclass
    # Return String with contents of variables file.
    def variables
      false
    end

    def create_param_file(app_template_path)
      parameters = parameters(app_template_path)

      lines = []
      required = required(parameters)
      lines << "# Required parameters:" unless required.empty?
      required.each do |name, data|
        example = description_example(data["Description"])
        lines << "#{name}=#{example}"
      end
      optional = optional(parameters)
      lines << "# Optional parameters:" unless optional.empty?
      optional.each do |name, data|
        value = default_value(data)
        lines << "# #{name}=#{value}"
      end

      if lines.empty?
        puts "Template has no parameters."
        return
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

    def default_value(data)
      value = data["Default"]
      if value.blank?
        description_example(data["Description"])
      else
        value
      end
    end

    def parameters(app_template_path)
      builder = Lono::Template::Dsl::Builder.new(app_template_path, @blueprint, quiet: false)
      template = builder.template
      template["Parameters"] || []
    end
    memoize :parameters

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