class Lono::Builder
  class Param < Lono::CLI::Base
    attr_reader :env_path, :base_path # set when build is called
    include Lono::Builder::Dsl::Syntax
    include Lono::Builder::Context
    # Overriding output resource DSL method
    alias_method :output, :stack_output

    def build
      load_context
      logger.info "Building parameters"

      contents = []

      layers.each do |layer|
        contents << render_erb(layer)
      end

      contents = contents.compact.join("\n") # result

      data = convert_to_cfn_format(contents)
      camel_data = convert_to_cfn_format(contents, :camel)
      json = JSON.pretty_generate(camel_data)
      write_output(json)
      unless @options[:mute]
        short_param_path = param_path.sub("#{Lono.root}/","")
        logger.info "    #{short_param_path}"
      end

      data
    end

    def layers
      Lono::Layering::Layer.new(@blueprint, "params").paths
    end

    def parameters
      build
    end

    def render_erb(path)
      return unless path
      if File.exist?(path)
        RenderMePretty.result(path, context: self)
      end
    end

    def convert_to_cfn_format(contents, casing=:underscore)
      lines = parse_contents(contents)

      # First use a Hash structure so that overlay env files will override
      # the base param file.
      data = {}
      lines.each do |line|
        key,value = line.strip.split("=").map {|x| x.strip}
        value = remove_surrounding_quotes(value)
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

    def remove_surrounding_quotes(s)
      if s =~ /^"/ && s =~ /"$/
        s.sub(/^["]/, '').gsub(/["]$/,'') # remove surrounding double quotes
      elsif s =~ /^'/ && s =~ /'$/
        s.sub(/^[']/, '').gsub(/[']$/,'') # remove surrounding single quotes
      else
        s
      end
    end

    def param_path
      "#{Lono.root}/output/#{@blueprint.name}/params.json"
    end

    def write_output(json)
      dir = File.dirname(param_path)
      FileUtils.mkdir_p(dir)
      IO.write(param_path, json)
    end
  end
end