module Lono::Configset
  class Builder
    include Lono::Utils::Logging

    def initialize(options)
      @options = options
      @configset = options[:configset]
      @type = options[:type] || "project"
    end

    def run
      check_configset_exist!
      structure = build
      logger.info YAML.dump(structure)
    end

    def check_configset_exist!
      exist = !!Lono::Finder::Configset.find(@configset)
      unless exist
        logger.info "configset #{@configset.color(:green)} not found."
        exit 1
      end
    end

    def build
      # Examples:
      #   Erb.new(options).build
      #   Dsl.new(options).build
      builder_class = "Lono::Configset::Strategy::#{strategy.camelize}"
      builder_class = Object.const_get(builder_class)
      full = builder_class.new(@options.merge(root: configset_root)).build
      if @options[:cli]
        full["Metadata"] # contains AWS::CloudFormation::Init and optional AWS::CloudFormation::Authentication
      else
        full # Combiner uses full metadata structure
      end
    end

    def strategy
      jadespec = Lono::Jadespec.new(configset_root, "unknown") # abusing Jadespec to get strategy
      jadespec.lono_strategy
    end

    def configset_root
      finder = finder_class.new
      found = finder.find(@configset, local_only: false)
      found.root if found
    end

    def finder_class
      case @type
      when "project"
        Lono::Finder::Configset
      when "blueprint"
        Lono::Finder::Blueprint::Configset
      end
    end
  end
end
