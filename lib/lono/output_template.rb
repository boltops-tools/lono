module Lono
  class OutputTemplate
    def initialize(blueprint, template)
      @blueprint, @template = blueprint, template
    end

    def data
      template_path = "#{Lono.config.output_path}/#{@blueprint}/templates/#{@template}.yml"
      check_template_exists(template_path)
      YAML.load(IO.read(template_path))
    end

    # Check if the template exists and print friendly error message.  Exits if it
    # does not exist.
    def check_template_exists(template_path)
      unless File.exist?(template_path)
        puts "The template #{template_path} does not exist. Are you sure you use the right template name?  The template name does not require the extension.".color(:red)
        exit 1
      end
    end

    def required_parameters
      parameters.reject { |logical_id, p| p["Default"] }
    end

    def optional_parameters
      parameters.select { |logical_id, p| p["Default"] }
    end

    def parameters
      data["Parameters"] || []
    end

  end
end
