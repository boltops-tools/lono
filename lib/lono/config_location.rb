module Lono
  class ConfigLocation < AbstractBase
    extend Memoist

    def initialize(config, options={}, env=Lono.env, root=Lono.root)
      super(options)
      # config can be params or variables
      @config, @options, @env, @root = config, options, env, root
      @requested = determine_requested
    end

    def lookup
      levels = []
      levels += direct_levels
      # Standard lookup paths
      template_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}/#{@template}/#{@requested}"
      env_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}/#{@requested}"
      config_level = "#{@root}/configs/#{@blueprint}/#{@config}/#{@requested}"
      generic_env = "#{@root}/configs/#{@blueprint}/#{@config}/#{@env}"
      levels += [template_level, env_level, config_level, generic_env]

      print_levels(levels)

      found = levels.find do |level|
        requested_file(level)
      end
      if found
        file = requested_file(found)
        using_message(file, @env)
        file
      end
    end

    def direct_levels
      [
        @requested, # IE: absolute full path
        "#{@root}/#{@requested}", # IE : relative path within lono project
      ]
    end

    def lookup_base
      base = "#{@root}/configs/#{@blueprint}/#{@config}/base"
      file = requested_file(base)
      if file
        using_message(file, "base")
        file
      end
    end

    def print_levels(levels)
      return unless ENV["LONO_DEBUG_CONFIG"]
      puts "levels #{@config}:"
      pp levels
    end

    @@using_message_displayed = {}
    def using_message(file, type)
      return if @@using_message_displayed[file]

      pretty_file = file.sub("#{Lono.root}/", "")
      puts "Using #{@config} for #{type}: #{pretty_file}"

      @@using_message_displayed[file] = true
    end

    # Some switching logic between variable and param below

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
