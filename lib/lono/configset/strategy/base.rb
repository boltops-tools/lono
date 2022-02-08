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

    # All Lono DSL Helpers and Fn - so configsets have access to instrinic functions like ref
    # Not including the Lono::Builder::Template::Strategy::Dsl::Evaluator::Syntax since dont need those methods
    #
    # Interesting note: must include these modules here so load_project_predefined_variables works.
    # Since load_project_predefined_variables calls evaluate_file / instance eval which seems to only be
    # able to access methods from the direct class, not inherited classes like Dsl.
    #
    # This allows methods like ref and sub to work in variables files.
    #
    include Lono::Builder::Template::Strategy::Dsl::Evaluator::Helpers
    include Lono::Builder::Template::Strategy::Dsl::Evaluator::Fn

    def initialize(options={})
      @options = options
      @configset = options[:configset]
      @root = options[:root]
      @resource = options[:resource] || "FakeResource"
      @blueprin = options[:blueprint]
    end

    def build
      @evaluation_path = find_evaluation_path # implemented by subclass
      copy_instance_variables
      load_configset_helpers
      init = load # implemented by subclass
      finish_full_structure(init)
    end
    memoize :build

    def finish_full_structure(init)
      full = {"Metadata" => {}}
      full["Metadata"]["AWS::CloudFormation::Init"] = init["AWS::CloudFormation::Init"]
      full["Metadata"]["AWS::CloudFormation::Authentication"] = authentication if authentication # only on dsl
      full.deep_stringify_keys!
    end

    def copy_instance_variables
      load_blueprint_predefined_variables
      load_project_predefined_variables
    end

    def load_blueprint_predefined_variables
      evaluate_file("#{@root}/lib/variables.rb")
    end

    def load_project_predefined_variables
      paths = [
        "#{Lono.root}/config/#{@blueprint.name}/configsets/variables.rb", # global
        "#{Lono.root}/config/#{@blueprint.name}/configsets/variables/#{@configset}.rb", # configset specific
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
