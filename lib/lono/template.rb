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
      lines = result.split("\n")
      lines.each do |line|
        output += transform(line)
      end
      output.to_json
    end

    def ref(name)
      %Q|{"Ref"=>"#{name}"}|
    end

    # http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-findinmap.html
    def find_in_map(*args)
      args.map! {|x| x =~ /=>/ ? x : x.inspect }
      %Q|{"Fn::FindInMap" => [ #{args.join(',')} ]}|
    end

    def base64(value)
      %Q|{"Fn::Base64"=>"#{value}"}|
    end

    def get_att(*args)
      args.map! {|x| x =~ /=>/ ? x : x.inspect }
      %Q|{"Fn::GetAtt" => [ #{args.join(',')} ]}|
    end

    def get_azs(region="AWS::Region")
      %Q|{"Fn::GetAZs"=>"#{region}"}|
    end

    def join(delimiter, values)
      values.map! {|x| x =~ /=>/ ? x : x.inspect }
      %Q|{"Fn::Join" => ["#{delimiter}", [ #{values.join(',')} ]]}|
    end

    def select(index, list)
      list.map! {|x| x =~ /=>/ ? x : x.inspect }
      %Q|{"Fn::Select" => ["#{index}", [ #{list.join(',')} ]]}|
    end

    # transform each line of the bash script into a UserData compatiable with CF template.
    #   any {"Ref"=>"..."} string get turned into CF Hash elements
    def transform(data)
      data = evaluate(data,/({"Fn::FindInMap" => \[ .* \]})/)
      data = evaluate(data,/({"Ref"=>".*?"})/)
      data = evaluate(data,/({"Fn::Base64"=>".*?"})/)
      data = evaluate(data,/({"Fn::GetAtt" => \[ .* \]})/)
      data = evaluate(data,/({"Fn::GetAZs"=>".*?"})/)
      data = evaluate(data,/({"Fn::Join" => \[".*?", \[ .* \]\]})/)
      data = evaluate(data,/({"Fn::Select" => \[".*?", \[ .* \]\]})/)

      # add newline at the end
      if data[-1].is_a?(String)
        data[0..-2] + ["#{data[-1]}\n"] 
      else
        data + ["\n"]
      end
    end

    # Input:
    #   String or Array of items (Strings or evaluated objects)
    # Output:
    #   Array of items (Strings or evaluated objects)
    #
    # if regex found in String, then match is eval into ruby code
    # if regex pattern not found, then original line is left alone
    def evaluate(line, regex)
      items = [line].flatten
      result = items.map do |item|
        if item.is_a?(String)
          data = item.split(regex)
          data.map {|l| l.match(regex) ? eval(l) : l }
        else
          item
        end
      end.flatten
    end
  end
end