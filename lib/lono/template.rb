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

    # transform each line of the bash script into a UserData compatiable with CF template.
    #   any {"Ref"=>"..."} string get turned into CF Hash elements
    def transform(line)
      regex = /({"Ref"=>".*?"})/
      data = line.split(regex)
      data.map! {|l| l.match(regex) ? eval(l) : l }
      if data[-1].is_a?(String)
        data[0..-2] + ["#{data[-1]}\n"] 
      else
        data + ["\n"]
      end
    end
  end
end