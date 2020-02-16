class Lono::Param
  class Generator < Lono::AbstractBase
    attr_reader :env_path, :base_path # set when generate is called

    def generate
      puts "Generating parameter files for blueprint #{@blueprint.color(:green)}:"

      contents = []
      layering = Lono::Layering.new("params", @options, Lono.env)
      layering.locations.each do |path|
        contents << render_erb(path)
      end
      contents = contents.compact.join("\n") # result

      data = convert_to_cfn_format(contents)
      camel_data = convert_to_cfn_format(contents, :camel)
      json = JSON.pretty_generate(camel_data)
      write_output(json)
      unless @options[:mute]
        short_output_path = output_path.sub("#{Lono.root}/","")
        puts "  #{short_output_path}"
      end

      data
    end

    def parameters
      generate
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

    def output_path
      "#{Lono.root}/output/#{@blueprint}/params/#{@stack}.json"
    end

    def write_output(json)
      dir = File.dirname(output_path)
      FileUtils.mkdir_p(dir)
      IO.write(output_path, json)
    end
  end
end