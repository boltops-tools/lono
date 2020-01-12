module Lono::Output
  class Template
    extend Memoist

    def initialize(blueprint, template)
      @blueprint, @template = blueprint, template
    end

    def required_parameters
      parameters.select { |logical_id, p| p["Default"].nil? }
    end

    def optional_parameters
      parameters.reject { |logical_id, p| p["Default"].nil? }
    end

    def parameters
      data["Parameters"] || []
    end

    def parameter_groups
      interface = data.dig("Metadata", "AWS::CloudFormation::Interface")
      return unless interface
      pgs = interface["ParameterGroups"]
      pgs.inject({}) do |result, pg|
        k = pg["Label"]["default"]
        v = pg["Parameters"]
        result.merge(k => v)
      end
    end

    def data
      template_path = "#{Lono.config.output_path}/#{@blueprint}/templates/#{@template}.yml"
      check_template_exists!(template_path)
      YAML.load(IO.read(template_path))
    end
    memoize :data

  private
    # Check if the template exists and print friendly error message.  Exits if it
    # does not exist.
    def check_template_exists!(template_path)
      return if File.exist?(template_path)
      puts "The template #{template_path} does not exist. Are you sure you use the right template name?  The template name does not require the extension.".color(:red)
      exit 1
    end
  end
end
