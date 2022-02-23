module Lono::Builder::Configset
  class Registration
    include DslEvaluator

    def initialize(blueprint)
      @blueprint = blueprint
    end

    cattr_accessor :metas, default: []
    def metas
      self.class.metas
    end

    def evaluate
      path = "#{@blueprint.root}/configsets.rb" # plural
      evaluate_file(path)
    end

    # Only one syntax method so not in separate module.
    #
    # Register configset for later processing.
    # By registering them all up front, can aggregate errors and show them together
    # for a user-friendly experience.
    #
    # The configset method is different with configset registration vs configset definition
    #
    #   definition:   app/configsets/httpd/configset.rb
    #   registration: app/blueprints/demo/configsets.rb
    #
    def configset(name, options={})
      found = metas.detect { |i| i[:name] == name && i[:resource] == options[:resource] }
      metas << options.merge(name: name) unless found
    end
  end
end
