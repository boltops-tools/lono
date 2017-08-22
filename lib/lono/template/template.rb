require 'erb'
require 'json'
require 'base64'

class Lono::Template::Template
  include Lono::Template::Helpers
  include ERB::Util

  def initialize(name, block=nil, options={})
    # Taking care to name instance variables with _ in front because we load the
    # variables from config/variables and those instance variables can clobber these
    # instance variables
    @_name = name
    @_options = options
    @_detected_format = options[:detected_format]
    @_block = block
    @_project_root = options[:project_root] || '.'
    @_config_path = "#{@_project_root}/config"
    @_source = default_source(name)
  end

  def default_source(name)
    "#{@_project_root}/templates/#{name}.#{@_detected_format}" # defaults to name, source method overrides
  end

  def build
    load_variables
    load_custom_helpers
    instance_eval(&@_block) if @_block
    template = IO.read(@_source)
    erb_result(@_source, template)
  end

  def load_variables
    load_variables_folder("base")
    load_variables_folder(LONO_ENV)
  end

  # Load the variables defined in config/variables/* to make available in the
  # template blocks in config/templates/*.
  #
  # Example:
  #
  #   `config/variables/base/variables.rb`:
  #     @foo = 123
  #
  #   `config/templates/base/resources.rb`:
  #      template "mytemplate.yml" do
  #        source "mytemplate.yml.erb"
  #        variables(foo: @foo)
  #      end
  #
  # NOTE: Only able to make instance variables avaialble with instance_eval
  #   Wasnt able to make local variables available.
  def load_variables_folder(folder)
    paths = Dir.glob("#{@_config_path}/variables/#{folder}/**/*")
    paths.select{ |e| File.file? e }.each do |path|
      instance_eval(IO.read(path))
    end
  end

  # Load custom helper methods from the user's infra repo
  def load_custom_helpers
    Dir.glob("#{@_project_root}/helpers/**/*_helper.rb").each do |path|
      filename = path.sub(%r{.*/},'').sub('.rb','')
      module_name = filename.classify

      require path
      self.class.send :include, module_name.constantize
    end

  end

  def source(path)
    @_source = path[0..0] == '/' ? path : "#{@_project_root}/templates/#{path}"
    @_source += ".#{@_detected_format}"
  end

  def variables(vars={})
    vars.each do |var,value|
      instance_variable_set("@#{var}", value)
    end
  end

  def erb_result(path, template)
    begin
      ERB.new(template, nil, "-").result(binding)
    rescue Exception => e
      puts e
      puts e.backtrace if ENV['DEBUG']

      # how to know where ERB stopped? - https://www.ruby-forum.com/topic/182051
      # syntax errors have the (erb):xxx info in e.message
      # undefined variables have (erb):xxx info in e.backtrac
      error_info = e.message.split("\n").grep(/\(erb\)/)[0]
      error_info ||= e.backtrace.grep(/\(erb\)/)[0]
      raise unless error_info # unable to find the (erb):xxx: error line
      line = error_info.split(':')[1].to_i
      puts "Error evaluating ERB template on line #{line.to_s.colorize(:red)} of: #{path.sub(/^\.\//, '').colorize(:green)}"

      template_lines = template.split("\n")
      context = 5 # lines of context
      top, bottom = [line-context-1, 0].max, line+context-1
      spacing = template_lines.size.to_s.size
      template_lines[top..bottom].each_with_index do |line_content, index|
        line_number = top+index+1
        if line_number == line
          printf("%#{spacing}d %s\n".colorize(:red), line_number, line_content)
        else
          printf("%#{spacing}d %s\n", line_number, line_content)
        end
      end
      exit 1 unless ENV['TEST']
    end
  end

  def transform_array(arr)
    arr.map! {|x| x =~ /=>/ ? x : x.inspect }
    arr.join(',')
  end

  # transform each line of bash script to array with cloudformation template objects
  def transform(data)
    data = evaluate(data)
    if data[-1].is_a?(String)
      data[0..-2] + ["#{data[-1]}\n"]
    else
      data + ["\n"]
    end
  end

  # Input:
  #   String
  # Output:
  #   Array of parse positions
  #
  # The positions of tokens taking into account when brackets start and close,
  # handles nested brackets.
  def bracket_positions(line)
    positions,pair,count = [],[],0

    line.split('').each_with_index do |char,i|
      pair << i if pair.empty?

      first_pair_char = line[pair[0]]
      if first_pair_char == '{' # object logic
        if char == '{'
          count += 1
        end

        if char == '}'
          count -= 1
          if count == 0
            pair << i
            positions << pair
            pair = []
          end
        end
      else # string logic
        lookahead = line[i+1]
        if lookahead == '{'
          pair << i
          positions << pair
          pair = []
        end
      end
    end # end of loop

    # for string logic when lookahead does not contain a object token
    # need to clear out what's left to match the final pair
    if !pair.empty?
      pair << line.size - 1
      positions << pair
    end

    positions
  end

  # Input:
  #   Array - bracket_positions
  # Ouput:
  #   Array - positions that can be use to determine what to parse
  def parse_positions(line)
    positions = bracket_positions(line)
    positions.flatten
  end

  # Input
  #   String line of code to decompose into chunks, some can be transformed into objects
  # Output
  #   Array of strings, some can be transformed into objects
  #
  # Example:
  # line = 'a{b}c{d{d}d}e' # nested brackets
  # template.decompose(line).should == ['a','{b}','c','{d{d}d}','e']
  def decompose(line)
    positions = parse_positions(line)
    return [line] if positions.empty?

    result = []
    str = ''
    until positions.empty?
      left = positions.shift
      right = positions.shift
      token = line[left..right]
      # if cfn object, add to the result set but after clearing out
      # the temp str that is being built up when the token is just a string
      if cfn_object?(token)
        unless str.empty? # first token might be a object
          result << str
          str = ''
        end
        result << token
      else
        str << token # keeps building up the string
      end
    end

    # at the of the loop there's a leftover string, unless the last token
    # is an object
    result << str unless str.empty?

    result
  end

  def cfn_object?(s)
    exact = %w[Ref]
    pattern = %w[Fn::]
    exact_match = !!exact.detect {|word| s.include?(word)}
    pattern_match = !!pattern.detect {|p| s =~ Regexp.new(p)}
    (exact_match || pattern_match) && s =~ /^{/ && s =~ /=>/
  end

  def recompose(decomposition)
    decomposition.map { |s| cfn_object?(s) ? eval(s) : s }
  end

  def evaluate(line)
    recompose(decompose(line))
  end

  # For simple just parameters files that can also be generated with lono, the CFN
  # Fn::Base64 function is not available and as lono is not being used in the context
  # of CloudFormation.  So this can be used in it's place.
  def encode_base64(text)
    Base64.strict_encode64(text).strip
  end

  def name
    @_name
  end
end
