module Lono
  class Location
    extend Memoist

    def initialize(options, root=Lono.root, env=Lono.env)
      @stack = options[:stack]
      @blueprint = options[:blueprint]
      @template = options[:template]
      @requested = options[:param] || options[:stack]
      @root, @env = root, env
    end

    def lookup
      levels = []
      levels += direct_levels unless @env == "base"
      # Standard lookup paths
      template_level = "#{@root}/configs/#{@blueprint}/params/#{@env}/#{@template}/#{@requested}"
      env_level = "#{@root}/configs/#{@blueprint}/params/#{@env}/#{@requested}"
      params_level = "#{@root}/configs/#{@blueprint}/params/#{@requested}"
      generic_env = "#{@root}/configs/#{@blueprint}/params/#{@env}"
      levels += [template_level, env_level, params_level, generic_env]

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
