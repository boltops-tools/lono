class Lono::Jade
  class Registry
    attr_reader :args, :options
    attr_accessor :caller_line, :parent, :depends_on
    def initialize(args, options)
      @args, @options = args, options
    end

    def name
      @args.first
    end

    def gem_options
      options = @options.dup
      # Delete special options that is not supported by bundler Gemfile
      options.delete(:repo)
      options.delete(:resource) # configset
      options.delete(:vars) # configset
      options
    end

    # configset
    def resource
      @options[:resource]
    end

    def resource=(v)
      @options[:resource] = v
    end

    def vars
      options[:vars] || {}
    end

    class_attribute :tracked_configsets, default: []
    class_attribute :downloaded_configsets, default: []
    class_attribute :tracked_extensions, default: []
    class_attribute :downloaded_extensions, default: []

    class << self
      def register_configset(args, options)
        registry = new(args, options)
        jade_type = determine_jade_type(caller)
        jade = Lono::Jade.new(registry.name, jade_type, registry)
        self.tracked_configsets << jade
        registry
      end

      def determine_jade_type(caller)
        if caller.detect { |l| l =~ %r{config/configsets.rb} }
          'blueprint/configset'
        else
          'configset'
        end
      end

      def register_extension(args, options)
        registry = new(args, options)
        self.tracked_extensions << registry
        registry
      end
    end
  end
end
