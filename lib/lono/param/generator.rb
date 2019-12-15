class Lono::Param
  class Generator < Lono::AbstractBase
    attr_reader :env_path, :base_path # set when generate is called

    def generate
      puts "Generating parameter files for blueprint #{@blueprint.color(:green)}:"

      @base_path, @env_path = config_locations

      return {} unless @base_path || @env_path

      # useful option for lono cfn, since some templates dont require params
      return {} if @options[:allow_not_exists] && !params_exist?

      if params_exist?
        contents = process_erb
        data = convert_to_cfn_format(contents)
        camel_data = convert_to_cfn_format(contents, :camel)
        json = JSON.pretty_generate(camel_data)
        write_output(json)
        unless @options[:mute]
          short_output_path = output_path.sub("#{Lono.root}/","")
          puts "  #{short_output_path}"
        end
      else
        puts "#{@base_path} or #{@env_path} could not be found?  Are you sure it exist?"
        exit 1
      end
      data
    end

    def parameters
      generate
    end

    def config_locations
      @base_path = lookup_config_location("base")
      @env_path = lookup_config_location(Lono.env)

      if ENV['LONO_DEBUG_PARAM']
        puts "LONO_DEBUG_PARAM enabled"
        puts "  @base_path #{@base_path.inspect}"
        puts "  @env_path #{@env_path.inspect}"
      end

      [@base_path, @env_path]
    end

    def lookup_config_location(env)
      location = Lono::ConfigLocation.new("params", @options, env)
      env == "base" ? location.lookup_base : location.lookup
    end

    def puts_param_message(type)
      path = send("#{type}_path")
      return unless path
      if param_file?(path)
        pretty_path = path.sub("#{Lono.root}/",'')
        puts "Using param for #{type}: #{pretty_path}".color(:yellow)
      end
    end

    # Checks both base and source path for existing of the param file.
    # Example:
    #   params/base/mystack.txt - base path
    #   params/production/mystack.txt - source path
    def params_exist?
      @base_path && File.exist?(@base_path) ||
      @env_path && File.exist?(@env_path)
    end

    # Reads both the base source and env source and overlay the two
    # Example 1:
    #   params/base/mystack.txt - base path
    #   params/production/mystack.txt - env path
    #
    #   the base/mystack.txt gets combined with the prod/mystack.txt
    #   it produces a final prod/mystack.txt
    #
    # Example 2:
    #   params/base/mystack.txt - base path
    #
    #   the base/mystack.txt is used to produced a prod/mystack.txt
    #
    # Example 3:
    #   params/production/mystack.txt - env path
    #
    #   the prod/mystack.txt is used to produced a prod/mystack.txt
    def process_erb
      contents = []
      contents << render_erb(@base_path)
      contents << render_erb(@env_path)
      result = contents.compact.join("\n")
      # puts "process_erb result".color(:yellow)
      # puts result
      result
    end

    def render_erb(path)
      return unless path
      if File.exist?(path)
        RenderMePretty.result(path, context: context)
      end
    end

    # Context for ERB rendering.
    # This is where we control what references get passed to the ERB rendering.
    def context
      @context ||= Lono::Template::Context.new(@options)
    end

    def parse_contents(contents)
      lines = contents.split("\n")
      # remove comment at the end of the line
      lines.map! { |l| l.sub(/#.*/,'').strip }
      # filter out commented lines
      lines = lines.reject { |l| l =~ /(^|\s)#/i }
      # filter out empty lines
      lines = lines.reject { |l| l.strip.empty? }
      lines
    end

    def convert_to_cfn_format(contents, casing=:underscore)
      lines = parse_contents(contents)

      # First use a Hash structure so that overlay env files will override
      # the base param file.
      data = {}
      lines.each do |line|
        key,value = line.strip.split("=").map {|x| x.strip}
        data[key] = value
      end

      # Now build up the aws json format for parameters
      params = []
      data.each do |key,value|
        param = if value == "use_previous_value" || value == "UsePreviousValue"
                  {
                    "ParameterKey": key,
                    "UsePreviousValue": true
                  }
                elsif value
                  {
                    "ParameterKey": key,
                    "ParameterValue": value
                  }
                end
        if param
          param = param.to_snake_keys if casing == :underscore
          params << param
        end
      end
      params
    end

    def output_path
      output = Lono.config.output_path.sub("#{Lono.root}/","")
      path = if @base_path && !@env_path
               # Handle case when base config exist but the env config does not
               @base_path.sub("configs", output).sub("base", Lono.env)
             else
               @env_path.sub("configs", output)
             end
      path.sub(/\.txt$/,'.json')
    end

    def write_output(json)
      dir = File.dirname(output_path)
      FileUtils.mkdir_p(dir)
      IO.write(output_path, json)
    end
  end
end