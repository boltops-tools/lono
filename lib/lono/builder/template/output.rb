class Lono::Builder::Template
  class Output
    extend Memoist

    def initialize(blueprint)
      @blueprint = blueprint
    end

    def required_parameters
      parameters.select { |logical_id, p| p["Default"].nil? }
    end

    def optional_parameters
      parameters.reject { |logical_id, p| p["Default"].nil? }
    end

    def parameters
      list = data["Parameters"] || []
      # Not using sort_parameter_group because structure is different
      list.sort_by do |name, data|
        optional = !data["Default"].nil?
        [optional, name].join('-')
      end.to_h
    end

    def parameter_groups
      interface = data.dig("Metadata", "AWS::CloudFormation::Interface")
      return unless interface
      pgs = interface["ParameterGroups"]
      pgs.inject({}) do |result, pg|
        label = pg["Label"]["default"]
        parameters = sort_parameter_group(pg["Parameters"])
        result.merge(label => parameters)
      end
    end

    def outputs
      data["Outputs"] || {}
    end

    def resources
      data["Resources"] || {}
    end

    def data
      template_path = "#{Lono.root}/output/#{@blueprint.name}/template.yml"
      check_template_exists!(template_path)
      YAML.load(IO.read(template_path))
    end
    memoize :data

  private
    def sort_parameter_group(list)
      list.sort_by do |name|
        raw_parameters = data["Parameters"] || []
        param = raw_parameters[name]
        optional = !param["Default"].nil?
        [optional, name].join('-')
      end
    end

    # Check if the template exists and print friendly error message.  Exits if it
    # does not exist.
    def check_template_exists!(template_path)
      return if File.exist?(template_path)
      raise "The template #{template_path} does not exist. Are you sure you use the right template name?  The template name does not require the extension.".color(:red)
    end
  end
end
