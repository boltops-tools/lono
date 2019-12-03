module Lono
  class ConfigLocation
    extend Memoist
    include Lono::Conventions

    def initialize(config, options={}, env=Lono.env, root=Lono.root)
      @config = config # params or variables

      @stack = options[:stack]
      @blueprint = options[:blueprint]
      template, _ = template_param_convention(options)
      @template = options[:template] || template
      @root, @env = root, env

      # param is usually set from the convention. when set from convention stack name takes higher precedence
      param_from_convention = !options[:param]
      if param_from_convention
        @requested = options[:stack]
      else
        @requested = options[:param] || options[:stack]
      end
    end

    def lookup
      levels = []
      levels += direct_levels unless @env == "base"
      # Standard lookup paths
      template_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}/#{@template}/#{@requested}"
      env_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}/#{@requested}"
      config_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@requested}"
      generic_env = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}"
      levels += [template_level, env_level, config_level, generic_env]

      found = levels.find do |level|
        requested_file(level)
      end
      requested_file(found) if found
    end

    def direct_levels
      [
        @requested, # IE: absolute full path
        "#{@root}/#{@requested}", # IE : relative path within lono project
      ]
    end

    def requested_file(path)
      # List of paths to consider from initial path provided
      paths = [path, "#{path}.txt", "#{path}.sh"]
      paths.find { |p| File.file?(p) }
    end
    memoize :requested_file
  end
end
