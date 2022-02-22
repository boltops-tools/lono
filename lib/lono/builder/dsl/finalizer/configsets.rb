class Lono::Builder::Dsl::Finalizer
  class Configsets
    extend Memoist

    def initialize(cfn)
      @cfn = cfn
    end

    def run
      @cfn = add # overwrite
      @cfn
    end

    def add
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
      []
      # combiner = Lono::Configset::Combiner.new(@cfn, @options)
      # combiner.metadata_map
    end
    memoize :metadata_map
  end
end
