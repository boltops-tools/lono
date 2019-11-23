class Lono::Param
  class Generator
    include Lono::Blueprint::Root
    include Lono::Conventions

    attr_reader :env_path, :base_path # set when generate is called
    def initialize(blueprint, options={})
      @blueprint, @options = blueprint, options
      set_blueprint_root(@blueprint)
      @template, @param = template_param_convention(options)
    end

    def puts_param_message(type)
      path = send("#{type}_path")
      return unless path
      if File.exist?(path)
        pretty_path = path.sub("#{Lono.root}/",'')
        puts "Using param: #{pretty_path}".color(:yellow)
      end
    end

    # Lookup precedence:
    #
    #   configs/BLUEPRINT/params/development/TEMPLATE/PARAM.txt
    #   configs/BLUEPRINT/params/development/PARAM.txt
    #   configs/BLUEPRINT/params/development.txt
    #
    def lookup_param_file(root: Lono.root, env: Lono.env)
      direct_env_form = "#{root}/configs/#{@blueprint}/params/#{env}/#{@param}.txt" # direct lookup is simple
      direct_simple_form = "#{root}/configs/#{@blueprint}/params/#{@param}.txt" # direct lookup is simple
      long_form = "#{root}/configs/#{@blueprint}/params/#{env}/#{@template}/#{@param}.txt"
      medium_form = "#{root}/configs/#{@blueprint}/params/#{env}/#{@param}.txt"
      short_form = "#{root}/configs/#{@blueprint}/params/#{env}.txt"

      if ENV['LONO_PARAM_DEBUG']
        puts "Lono.blueprint_root #{Lono.blueprint_root}"
        puts "direct_env_form #{direct_env_form}"
        puts "direct_simple_form #{direct_simple_form}"
        puts "long_form #{long_form}"
        puts "medium_form #{medium_form}"
        puts "short_form #{short_form}"
      end

      return direct_env_form if File.exist?(direct_env_form) # always consider this first its simple and direct but is scope to env so it's more specific
      return direct_simple_form if File.exist?(direct_simple_form) # always consider this first its simple and direct but is scope to env so it's more specific
      return long_form if File.exist?(long_form) # consider this first because its more explicit

      # All 3 are the same
      # Also, blueprint and template the same and explicitly specified param
      if @blueprint == @template
        return medium_form if File.exist?(medium_form) # higher precedence between longer but short form should be encouraged
        return short_form if File.exist?(short_form)
        return # cannot find a param file
      end

      # Only template and param are the same
      if @template == @param
        return medium_form if File.exist?(medium_form) # only consider medium form
        return # cannot find a param file
      end
    end

    def lookup_paths
      @base_path = lookup_param_file(env: "base")
      @env_path = lookup_param_file(env: Lono.env)

      if ENV['LONO_PARAM_DEBUG']
        puts "  @base_path #{@base_path.inspect}"
        puts "  @env_path #{@env_path.inspect}"
      end

      [@base_path, @env_path]
    end

    def generate
      puts "Generating parameter files for blueprint #{@blueprint.color(:green)}:"

      @base_path, @env_path = lookup_paths

      return unless @base_path || @env_path

      # useful option for lono cfn, since some templates dont require params
      return if @options[:allow_not_exists] && !source_exist?

      if source_exist?
        contents = process_erb
        data = convert_to_cfn_format(contents)
        json = JSON.pretty_generate(data)
        write_output(json)
        unless @options[:mute]
          short_output_path = output_path.sub("#{Lono.root}/","")
          puts "  #{short_output_path}"
        end
      else
        puts "#{@base_path} or #{@env_path} could not be found?  Are you sure it exist?"
        exit 1
      end
      json
    end

    # Checks both base and source path for existing of the param file.
    # Example:
    #   params/base/mystack.txt - base path
    #   params/production/mystack.txt - source path
    def source_exist?
      @base_path && File.exist?(@base_path) ||
      @env_path && File.exist?(@env_path)
    end

    # useful for when calling CloudFormation via the aws-sdk gem
    def params(casing = :underscore)
      @base_path, @env_path = lookup_paths

      # useful option for lono cfn
      return {} if @options[:allow_not_exists] && !source_exist?

      contents = process_erb
      convert_to_cfn_format(contents, casing)
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
      @context ||= Lono::Template::Context.new(@blueprint, @options)
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

    def convert_to_cfn_format(contents, casing=:camel)
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
        param = if value == "use_previous_value"
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