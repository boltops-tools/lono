module Lono
  class DSL
    def initialize(options={})
      @options = options
      @options[:project_root] ||= '.'
      @path = "#{@options[:project_root]}/config/lono.rb"
      @templates = []
      @results = {}
    end

    def evaluate
      instance_eval(File.read(@path), @path)
      load_subfolder
    end

    # load any templates defined in project/config/lono/*
    def load_subfolder
      Dir.glob("#{File.dirname(@path)}/lono/*").each do |path|
        instance_eval(File.read(path), path)
      end
    end

    def template(name, &block)
      @templates << {:name => name, :block => block}
    end

    def build
      @templates.each do |t|
        @results[t[:name]] = Template.new(t[:name], t[:block], @options).build
      end
    end

    def output
      output_path = "#{@options[:project_root]}/output"
      FileUtils.rm_rf(output_path) if @options[:clean]
      FileUtils.mkdir(output_path) unless File.exist?(output_path)
      puts "Generating Cloud Formation templates:" unless @options[:quiet]
      @results.each do |name,json|
        path = "#{output_path}/#{name}"
        puts "  #{path}" unless @options[:quiet]
        pretty_json = JSON.pretty_generate(JSON.parse(json))
        File.open(path, 'w') {|f| f.write(pretty_json) }
      end
    end

    def run(options={})
      evaluate
      build
      output
    end
  end
end