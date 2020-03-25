require "yaml"

class Lono::Configset
  class Combiner
    def initialize(cfn, options={})
      @cfn, @options = cfn, options

      @sets = []
      @map = {} # stores resource logical id => metadata cfn-init
    end

    def generator_options(registry, options={})
      o = @options.merge(configset: registry.name, resource: registry.resource)
      o.merge(options)
    end

    def metadata_map
      return {} unless additional_configsets?

      existing_configsets.each do |data|
        add(data[:registry], data[:metdata_configset])
      end

      Register::Blueprint.configsets.each do |registry|
        generator = Lono::Configset::Generator.new(generator_options(registry, type: "blueprint"))
        cloudformation_init = generator.build
        add(registry, cloudformation_init)
      end
      Register::Project.configsets.each do |registry|
        generator = Lono::Configset::Generator.new(generator_options(registry, type: "project"))
        cloudformation_init = generator.build
        add(registry, cloudformation_init)
      end

      combine
      Register::Blueprint.clear! # in case of lono generate for all templates
      Register::Project.clear! # in case of lono generate for all templates
      @map
    end

    def add(registry, metadata)
      @sets << [registry, metadata.dup]
    end

    def additional_configsets?
      !Register::Blueprint.configsets.empty? || !Register::Project.configsets.empty?
    end

    # Normalized/convert cfn template to mimic the registry format
    def existing_configsets
      configsets = []
      @cfn["Resources"].each do |logical_id, attributes|
        init = attributes.dig("Metadata", "AWS::CloudFormation::Init")

        next unless init

        data = {
          registry: Lono::Jade::Registry.new(["#{logical_id}OriginalConfigset"], resource: logical_id),
          metdata_configset: {"Metadata" => attributes["Metadata"]} #  # wrap metadata to create right structure
        }
        configsets << data
      end
      configsets
    end

    def combine
      # Remove duplicate configsets. Can happen if same configset is in blueprint and project.
      # Ugly because of the sets structure.
      @sets.uniq! do |array|
        registry, _ = array
        registry.name
      end

      metadata_map = {}
      configsets_map = {}

      @sets.each_with_index do |array, i|
        padded_i = "%03d" % i
        registry, metadata = array

        # metadata example (full structure):
        #
        #     {"Metadata"=>
        #       {"AWS::CloudFormation::Init"=>
        #         {"configSets"=>{"default"=>["aaa1", "aaa2"]},
        #         "aaa1"=>{"commands"=>{"test"=>{"command"=>"echo from-aaa1 > test1.txt"}}},
        #         "aaa2"=>
        #           {"commands"=>{"test"=>{"command"=>"echo from-aaa2 > test1.txt"}}}}}}

        name, resource = registry.name, registry.resource
        configsets = configsets_map[resource] ||= {}

        validate_structure!(name, metadata)

        new_metadata = metadata["Metadata"].dup
        init = new_metadata["AWS::CloudFormation::Init"] # important: adjust data by reference

        if init.key?("configSets")
          validate_simple!(registry, new_metadata["AWS::CloudFormation::Init"]["configSets"]) # validate original configset for only simple elements

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

    def validate_structure!(name, metadata)
      return if metadata.is_a?(Hash) && metadata.dig("Metadata", "AWS::CloudFormation::Init")

      puts "ERROR: The #{name} configset does not appear to have a AWS::CloudFormation::Init key".color(:red)
      puts "Please double check the #{name} configset.yml structure"
      exit 1
    end

    def validate_simple!(registry, cs)
      has_complex_type = cs["default"].detect { |s| !s.is_a?(String) }
      if has_complex_type
        message =<<~EOL
          ERROR: The configset #{registry.name} has a configSets property with a complex type.
          configSets:

              #{cs}

          lono configsets only supports combining configSets with an Array of Strings.
        EOL
        if ENV['LONO_TEST']
          raise message
        else
          puts message.color(:red)
          exit 1
        end
      end
    end
  end
end
