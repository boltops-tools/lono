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

    def partial(path)
      path = "#{@options[:project_root]}/templates/partial/#{path}"
      template = IO.read(path)
      ERB.new(template).result(binding)
    end

    def user_data(path)
      path = "#{@options[:project_root]}/templates/user_data/#{path}"
      template = IO.read(path)
      result = ERB.new(template).result(binding)
      output = []
      result.split("\n").each do |line|
        output += transform(line)
      end
      output.to_json
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

    # transform each line of bash script to array with cloud formation template objects
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
    # The positions indicate when the brackets start and close.  
    # Handles nested brackets.
    def bracket_positions(line)
      positions,pair,count = [],[],0
      line.split('').each_with_index do |char,i|
        if char == '{'
          count += 1
          pair << i if count == 1
          next
        end

        if char == '}'
          count -= 1
          if count == 0
            pair << i
            positions << pair
            pair = []
          end
        end
      end
      positions
    end

    # Input:
    #   Array - bracket_positions
    # Ouput:
    #   Array - positions that can be use to determine what to parse
    def parse_positions(line)
      positions = bracket_positions(line)
      # add 1 to the element in the position pair to make parsing easier in decompose
      positions.map {|pair| [pair[0],pair[1]+1]}.flatten
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
      last_index = line.size - 1
      parse_position = positions.shift

      line.split('').each_with_index do |char,current_i|
        # the current item's creation will end when
        #   the next item's index is reached
        #   or the end of the line is reached
        str << char
        next_i = current_i + 1
        end_of_item = next_i == parse_position
        end_of_line = current_i == last_index
        if end_of_item or end_of_line
          parse_position = positions.shift
          result << str
          str = ''
        end
      end

      result
    end

    def recompose(decomposition)
      decomposition.map { |s| (s =~ /^{/ && s =~ /=>/) ? eval(s) : s }
    end

    def evaluate(line)
      recompose(decompose(line))
    end
  end
end