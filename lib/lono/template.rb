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

    # transform each line of the bash script into a UserData compatiable with CF template.
    #   any {"Ref"=>"..."} string get turned into CF Hash elements
    def transform(line)
      # Fn::FindInMap transform, also takes care of nested Ref transform
      data = evaluate(line,/({"Fn::FindInMap" => \[ .* \]})/)

      # Ref transform
      already_transformed = data.size > 1
      unless already_transformed
        data = evaluate(line,/({"Ref"=>".*?"})/)
      end

      # add newline at the end
      if data[-1].is_a?(String)
        data[0..-2] + ["#{data[-1]}\n"] 
      else
        data + ["\n"]
      end
    end

    # if regex found in line, the match is eval into ruby code
    #   returns array of evaluated items
    # if regex pattern not found
    #   returns array with original line
    def evaluate(line, regex)
      data = line.split(regex)
      data.map {|l| l.is_a?(String) && l.match(regex) ? eval(l) : l }
    end
  end
end