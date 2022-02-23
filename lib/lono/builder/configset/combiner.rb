module Lono::Builder::Configset
  class Combiner < Lono::CLI::Base
    def initialize(options={})
      super
      @cfn = options[:cfn]     # merge from Dsl::Finalizer::Configsets#run
      @metas = options[:metas] # merge from Configset::Evaluator#evaluate
      @configsets = []
      @map = {} # stores resource logical id => metadata cfn-init
    end

    # Returns metadata map structure
    #
    # {"Instance"=>
    #   {"Metadata"=>
    #     {"AWS::CloudFormation::Init"=>
    #
    def combine
      return @map if metas_empty?
      add_existing
      add_built
      build_map # metadata map
    end

    def metas_empty?
      @metas.empty?
    end

    def add_existing
      existing_configsets.each do |configset|
        add(configset)
      end
    end

    def add_built
      @metas.each do |meta|
        definition = Definition.new(@options.merge(meta: meta))
        configset = definition.evaluate
        add(configset)
      end
    end

    # Useful for specs
    def add(configset)
      found = @configsets.detect { |c| c.name == configset.name && c.resource == configset.resource }
      @configsets << configset unless found
    end

    # Each metadata has this structure:
    #
    #     {"Metadata"=>
    #       {"AWS::CloudFormation::Init"=>
    #         {"configSets"=>{"default"=>["aaa1", "aaa2"]},
    #         "aaa1"=>{"commands"=>{"test"=>{"command"=>"echo from-aaa1 > test1.txt"}}},
    #         "aaa2"=>
    #           {"commands"=>{"test"=>{"command"=>"echo from-aaa2 > test1.txt"}}}}}}
    #
    def build_map
      metadata_map = {}
      configsets_map = {}

      @configsets.each_with_index do |configset, i|
        padded_i = "%03d" % i

        name, resource, metadata = configset.name, configset.resource, configset.metadata
        configsets = configsets_map[resource] ||= {}

        validate_structure!(name, metadata)

        new_metadata = metadata["Metadata"].dup
        init = new_metadata["AWS::CloudFormation::Init"] # important: adjust data by reference

        if init.key?("configSets")
          # validate_simple!(name, new_metadata["AWS::CloudFormation::Init"]["configSets"]) # validate original configset for only simple elements

          # 1. expand each config as its own config, flattening to top-level
          cs = init.delete("configSets") # Only support configSets with simple Array of Strings
          new_config_set = {}
          new_config_set[name] = cs["default"].map {|c| "#{padded_i}_#{c}" }
          init.transform_keys! { |c| "#{padded_i}_#{c}" }

          # Rebuild default configSet, append the new complex ConfigSet structure with each iteration
          configsets["default"] ||= []
          configsets["default"] << {"ConfigSet" => name}
          configsets.merge!(new_config_set) # add each config from #1 to the top-level

          init["configSets"] = configsets # replace new configset
        else # simple config
          init["configSets"] = configsets # adjust data by reference
          configsets["default"] ||= []
          configsets["default"] << {"ConfigSet" => name}

          # build new config
          config_key = "#{padded_i}_single_generated"
          configsets[name] = [config_key]
          new_config = {config_key => init["config"]}
          # replace old config with new one
          init.delete("config") # delete original simple config
          init.merge!(new_config)
        end

        metadata_map[resource] ||= {"Metadata" => {}}
        metadata_map[resource]["Metadata"].deep_merge!(new_metadata)
        @map[resource] = metadata_map[resource]
      end
      @map
    end

    # Normalized/convert cfn template to mimic the registry format
    def existing_configsets
      configsets = []
      @cfn["Resources"].each do |logical_id, attributes|
        cloudformation_init = attributes.dig("Metadata", "AWS::CloudFormation::Init")
        next unless cloudformation_init

        configset = Lono::Configset.new(name: "#{logical_id}OriginalConfigset", resource: logical_id)
        configset.metadata = {"Metadata" => attributes["Metadata"]} # wrap metadata to create right structure
        configsets << configset
      end
      configsets
    end

    def validate_structure!(name, metadata)
      return if metadata.is_a?(Hash) && metadata.dig("Metadata", "AWS::CloudFormation::Init")

      puts "ERROR: The #{name} configset does not appear to have a AWS::CloudFormation::Init key".color(:red)
      puts "Please double check the #{name} configset.yml structure"
      exit 1
    end

    def validate_simple!(name, cs)
      has_complex_type = cs["default"].detect { |s| !s.is_a?(String) }
      return unless has_complex_type
      message =<<~EOL
        ERROR: The configset #{name} has a configSets property with a complex type.
        configSets:

            #{cs}

        lono configsets only supports combining configSets with an Array of Strings.
      EOL
      puts message.color(:red)
      exit 1
    end
  end
end
