require 'erb'
require 'json'

module Lono
  class Template
    include ERB::Util

    attr_reader :name
    def initialize(name, block, options={})
      @name = name
      @block = block
      @options = options
    end

    def build
      instance_eval(&@block)
      template = IO.read(@source)
      ERB.new(template).result(binding)
    end

    def source(path)
      @source = path[0..0] == '/' ? path : "#{@options[:project_root]}/templates/#{path}"
    end

    def variables(vars={})
      vars.each do |var,value|
        instance_variable_set("@#{var}", value)
      end
    end

    def partial(path,vars={})
      path = "#{@options[:project_root]}/templates/partial/#{path}"
      template = IO.read(path)
      variables(vars)
      ERB.new(template).result(binding)
    end

    def user_data(path, vars={})
      path = "#{@options[:project_root]}/templates/user_data/#{path}"
      template = IO.read(path)
      variables(vars)
      result = ERB.new(template).result(binding)
      output = []
      result.split("\n").each do |line|
        output += transform(line)
      end
      json = output.to_json
      json[0] = '' # remove first char: [
      json.chop!   # remove last char:  ]
    end

    def ref(name)
      %Q|{"Ref"=>"#{name}"}|
    end

    def find_in_map(*args)
      %Q|{"Fn::FindInMap" => [ #{transform_array(args)} ]}|
    end

    def base64(value)
      %Q|{"Fn::Base64"=>"#{value}"}|
    end

    def get_att(*args)
      %Q|{"Fn::GetAtt" => [ #{transform_array(args)} ]}|
    end

    def get_azs(region="AWS::Region")
      %Q|{"Fn::GetAZs"=>"#{region}"}|
    end

    def join(delimiter, values)
      %Q|{"Fn::Join" => ["#{delimiter}", [ #{transform_array(values)} ]]}|
    end

    def select(index, list)
      %Q|{"Fn::Select" => ["#{index}", [ #{transform_array(list)} ]]}|
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
  end
end
