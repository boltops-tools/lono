class Lono::Configset
  class Registry
    attr_reader :args, :options
    attr_accessor :caller_line, :parent, :depends_on
    def initialize(args, options)
      @args, @options = args, options
    end

    def name
      @args.first
    end

    def resource
      @options[:resource]
    end

    def resource=(v)
      @options[:resource] = v
    end

    def gem_options
      options = @options.dup
      # Delete special options that is not supported by bundler Gemfile
      options.delete(:repo)
      options.delete(:resource)
      options.delete(:vars)
      options
    end

    def vars
      options[:vars] || {}
    end
  end
end
