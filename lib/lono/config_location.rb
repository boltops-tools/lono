module Lono
  class ConfigLocation
    extend Memoist
    include Lono::Conventions

    def initialize(config, options={}, env=Lono.env, root=Lono.root)
      # config can be params or variables
      @config, @options, @root, @env = config, options, root, env

      @stack = options[:stack]
      @blueprint = options[:blueprint] || @stack
      @template, @param = template_param_convention(options)

      @requested = determine_requested
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

      print_levels(levels)

      found = levels.find do |level|
        requested_file(level)
      end
      if found
        file = requested_file(found)
        using_message(file)
        file
      end
    end

    def print_levels(levels)
      return unless ENV["LONO_DEBUG_CONFIG"]
      puts "levels:"
      pp levels
    end

    @@using_message_displayed = {}
    def using_message(file)
      return if @@using_message_displayed[file]

      pretty_file = file.sub("#{Lono.root}/", "")
      puts "Using #{@config} for #{@env}: #{pretty_file}"

      @@using_message_displayed[file] = true
    end

    def direct_levels
      [
        @requested, # IE: absolute full path
        "#{@root}/#{@requested}", # IE : relative path within lono project
      ]
    end

    # Some switching logic between variable and param below

    def determine_requested
      # param is usually set from the convention. when set from convention stack name takes higher precedence
      config_key = @config.singularize.to_sym # param or variable
      from_convention = !@options[config_key]
      if from_convention
        @options[:stack]
      elsif @config == "params"
        @options[:param] || @options[:stack]
      elsif @config == "variables"
        @options[:variable] || @options[:stack]
      end
    end

    def requested_file(path)
      # List of paths to consider from initial path provided
      paths = @config == "params" ?
                [path, "#{path}.txt", "#{path}.sh"] :
                [path, "#{path}.rb"]
      paths.find { |p| File.file?(p) }
    end
    memoize :requested_file
  end
end
