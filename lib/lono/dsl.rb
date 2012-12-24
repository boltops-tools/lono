require 'erb'
require 'json'

module Lono
  class DSL
    def initialize(options={})
      @options = options
      @path = options[:config_path] || 'config/lono.rb'
      @templates = []
      @results = {}
    end

    def evaluate
      instance_eval(File.read(@path), @path)
    end

    def template(name, &block)
      @templates << {:name => name, :block => block}
    end

    def build
      @templates.each do |t|
        @results[t[:name]] = Template.new(t[:name], t[:block], @options).build
      end
    end

    def output(options={})
      output_path = options[:output_path] || 'output'
      FileUtils.mkdir(output_path) unless File.exist?(output_path)
      puts "Generating Cloud Formation templates:" if options[:verbose]
      @results.each do |name,json|
        path = "#{output_path}/#{name}"
        puts "  #{path}" if options[:verbose]
        pretty_json = JSON.pretty_generate(JSON.parse(json))
        File.open(path, 'w') {|f| f.write(pretty_json) }
      end
    end

    def run(options={})
      evaluate
      build
      options.empty? ? output : output(options)
    end
  end

  class Template
    include ERB::Util

    def initialize(name, block, options={})
      @name = name
      @block = block
      @options = options
      @options[:project_root] ||= '.'
    end

    def build
      instance_eval(&@block)
      template = IO.read(@source)
      ERB.new(template).result(binding)
    end

    def source(path)
      @source = "#{@options[:project_root]}/templates/#{path}"
    end

    def variables(vars={})
      vars.each do |var,value|
        instance_variable_set("@#{var}", value)
      end
    end

    def user_data(path)
      path = "#{@options[:project_root]}/templates/user_data/#{path}"
      template = IO.read(path)
      ERB.new(template).result(binding).split("\n").to_json
    end
  end
end