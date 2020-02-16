class Lono::Configset
  class Generator
    def initialize(options)
      @options = options
      @configset = options[:configset]
      @type = options[:type] || "project"
    end

    def run
      check_configset_exist!
      structure = build
      puts YAML.dump(structure)
    end

    def check_configset_exist!
      exist = !!Lono::Finder::Configset.find(@configset)
      unless exist
        puts "configset #{@configset.color(:green)} not found."
        exit 1
      end
    end

    def build
      # Examples:
      #   Erb.new(options).build
      #   Dsl.new(options).build
      generator_class = "Lono::Configset::Strategy::#{strategy.camelize}"
      generator_class = Object.const_get(generator_class)
      generator_class.new(@options.merge(root: configset_root)).build
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
