class Lono::Builder::Template
  class ConfigsetInjector < Lono::CLI::Base
    def initialize(options={})
      super
    end

    def run
      @cfn = load_template # initial
      @cfn = inject # overwrite
      write(@cfn)
      @cfn
    end

    def inject
      metadata_map.each do |logical_id, metadata_configset|
        resource = @cfn["Resources"][logical_id]

        unless resource
          logger.info "WARN: Resources.#{logical_id} not found in the template. Are you sure you are specifying the correct resource id in your configsets configs?".color(:yellow)
          next
        end

        resource["Metadata"] ||= metadata_configset["Metadata"]

        # metdata = resource["Metadata"] ||= {}
        # metdata["AWS::CloudFormation::Init"] ||= {}
        # # The metadata_configset has been combined with the original AWS::CloudFormation::Init if it exists
        # metdata["AWS::CloudFormation::Init"] = metadata_configset["AWS::CloudFormation::Init"]
      end

      @cfn
    end

    def metadata_map
      combiner = Lono::Configset::Combiner.new(@cfn, @options)
      combiner.metadata_map
    end
    memoize :metadata_map

    def write(cfn)
      IO.write(template_path, YAML.dump(cfn))
    end

    def load_template
      YAML.load_file(template_path)
    end

    def template_path
      "#{Lono.root}/output/#{@blueprint.name}/templates/#{@template}.yml"
    end
  end
end
