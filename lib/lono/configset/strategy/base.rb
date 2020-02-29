# Subclasses must implement:
#
#   find_evaluation_path - use to set @evaluation_path
#   load
#
# Notable instance variables:
#
#   @evaluation_path - IE: lib/configset.rb or lib/configset.yml
#   @root - IE: /path/to/root/of/configset
#
module Lono::Configset::Strategy
  class Base
    extend Memoist
    include Lono::Configset::EvaluateFile

    def initialize(options={})
      @options = options
      @configset = options[:configset]
      @root = options[:root]
      @resource = options[:resource] || "FakeResource"
      @blueprint = Lono::Conventions.new(options).blueprint
    end

    def build
      @evaluation_path = find_evaluation_path # implemented by subclass
      copy_instance_variables
      load_configset_helpers
      load # implemented by subclass
    end
    memoize :build

    def copy_instance_variables
      load_blueprint_predefined_variables
      load_project_predefined_variables
    end

    def load_blueprint_predefined_variables
      evaluate_file("#{@root}/lib/variables.rb")
    end

    def load_project_predefined_variables
      paths = [
        "#{Lono.root}/configs/#{@blueprint}/configsets/variables.rb", # global
        "#{Lono.root}/configs/#{@blueprint}/configsets/variables/#{@configset}.rb", # configset specific
      ]
      paths.each do |path|
        evaluate_file(path)
      end
    end

    def load_configset_helpers
      paths = Dir.glob("#{@root}/lib/helpers/**/*.rb")
      paths.sort_by! { |p| p.size } # load possible namespaces first
      paths.each do |path|
        filename = path.sub(%r{.*/lib/helpers/},'').sub('.rb','')
        module_name = filename.camelize

        require path
        self.class.send :include, module_name.constantize
      end
    end
  end
end
