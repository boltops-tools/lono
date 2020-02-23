class Lono::Configset
  class Preparer < Lono::AbstractBase
    def initialize(options={})
      super
      @blueprint = Register::Blueprint.new(options)
      @project   = Register::Project.new(options)
      @meta      = Meta.new(options)
      @resolver  = Resolver.new
    end

    def run
      register
      resolve_dependencies # also calls jade.materialize
      register_dependencies
      materialize
      validate_all! # run after final materializer
    end

    # Stores configsets registry items
    def register
      @project.register   # IE: evaluates configs/BLUEPRINT/configsets/base.rb
      @blueprint.register # IE: evaluates BLUEPRINT/config/configsets.rb
    end

    def resolve_dependencies
      jades = Lono::Jade::Registry.tracked_configsets  # at this point only top-level
      @resolver.resolve(jades) # also calls jade.materialize
    end

    def register_dependencies
      @resolver.register
    end

    def materialize
      jades = Lono::Jade::Registry.downloaded_configsets
      Lono::Jade::Materializer::Final.new.build(jades)
    end

    def validate_all!
      @blueprint.validate!
      @project.validate!
    end
  end
end
