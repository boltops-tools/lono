module Lono
  class ConfigLocation
    extend Memoist
    include Lono::Conventions

    def initialize(config, options={}, env=Lono.env, root=Lono.root)
      @config = config # params or variables

      param_from_convention = !options[:param]
      @stack = options[:stack]
      @blueprint = options[:blueprint] || @stack
      @template, @param = template_param_convention(options)
      @root, @env = root, env

      # param is usually set from the convention. when set from convention stack name takes higher precedence
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

      if ENV["LONO_DEBUG_PARAM"]
        puts "levels:"
        pp levels
      end

      found = levels.find do |level|
        requested_file(level)
      end
      if found
        file = requested_file(found)
        using_message(file)
        file
      end
    end

    @@using_message_displayed = {}
    def using_message(file)
      return if @@using_message_displayed[file]

      pretty_file = file.sub("#{Lono.root}/", "")
      puts "Using param for #{@env}: #{pretty_file}".color(:yellow)

      @@using_message_displayed[file] = true
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
