module Lono
  class Layering < AbstractBase
    extend Memoist

    def initialize(config, options={}, env=Lono.env, root=Lono.root)
      super(options)
      # config can be params or variables
      @config, @options, @env, @root = config, options, env, root
      @requested = determine_requested
    end

    def locations
      paths = always + requested
      layers = paths.map do |path|
        requested_file(path)
      end.compact
      print_layers(layers)
      layers
    end

    def always
      base = "#{@root}/configs/#{@blueprint}/#{@config}/base"
      env = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}"
      [base, env]
    end

    def requested
      standard_layers + direct_layers
    end

    def standard_layers
      config_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@requested}"
      env_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}/#{@requested}"
      template_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}/#{@template}/#{@requested}"
      [config_level, env_level, template_level]
    end

    def direct_layers
      if @requested.starts_with?('/')
        [@requested] # IE: absolute full path
      else
        ["#{@root}/#{@requested}"] # IE : relative path within lono project]
      end
    end

    def print_layers(layers)
      return unless ENV["LONO_DEBUG_LAYERING"]
      puts "layers #{@config}:"
      pp layers
    end

    def determine_requested
      # param is usually set from the convention. when set from convention stack name takes higher precedence
      config_key = @config.singularize.to_sym # param or variable
      @options[config_key] || @options[:config] || @stack
    end

    def requested_file(path)
      # List of paths to consider from initial path provided. Combine params and variables possible paths for simplicity.
      paths = [path, "#{path}.txt", "#{path}.sh", "#{path}.rb"].compact
      paths.find { |p| File.file?(p) }
    end
    memoize :requested_file
  end
end
