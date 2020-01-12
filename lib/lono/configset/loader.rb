require "json"

class Lono::Configset
  class Loader
    extend Memoist
    include Dsl
    include EvaluateFile

    def initialize(registry={}, options={})
      @registry, @options = registry, options
      @name, @resource = registry.name, registry.resource
      @blueprint = Lono::Conventions.new(options).blueprint
    end

    def metdata_configset
      load
    end

    def load
      path = find_path
      copy_instance_variables
      content = RenderMePretty.result(path, context: self)
      if File.extname(path) == ".yml"
        load_yaml(content)
      else
        JSON.load(content)
      end
    end
    memoize :load

    def load_yaml(content)
      # Write to file so can use Yamler::Validator
      path = "/tmp/lono/configset.yml"
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, content)
      Lono::Yamler::Validator.new(path).validate!
      Lono::Yamler::Loader.new(content).load
    end

    def find_path
      paths = %w[configset.yml configset.json].map { |p| "#{configset_root}/lib/#{p}" }
      paths.find { |p| File.exist?(p) }
    end

    def configset_root
      config = finder_class.find(@name)
      unless config
        puts "finder_class #{finder_class}"
        raise "Unable to find configset #{@name.inspect}"
      end
      config.root
    end

    # Allow overriding in subclasses
    def finder_class
      Lono::Finder::Configset
    end

    def copy_instance_variables
      load_blueprint_predefined_variables
      load_project_predefined_variables
      load_inline_project_variables
    end

    def load_blueprint_predefined_variables
      path = "#{configset_root}/lib/variables.rb"
      evaluate_file(path)
    end

    def load_project_predefined_variables
      paths = [
        "#{Lono.root}/configs/#{@blueprint}/configsets/variables.rb", # global
        "#{Lono.root}/configs/#{@blueprint}/configsets/#{@name}/variables.rb", # configset specific
      ]
      paths.each do |path|
        evaluate_file(path)
      end
    end

    # Copy options from the original configset call as instance variables so its available. So:
    #
    #   configset("ssm", resource: "Instance", some_var: "test")
    #
    # Stores in the Configset::Registry
    #
    #   register = {name: "ssm", resource: "Instance", some_var: "test"}
    #
    # That has is passed into Loader.new(register, options)
    #
    # So these @registry varibles are copied over to instance variables.
    #
    def load_inline_project_variables
      @registry.vars.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
  end
end
