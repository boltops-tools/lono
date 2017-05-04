module Lono
  class DSL
    def initialize(options={})
      @options = options
      @options[:project_root] ||= '.'
      @path = "#{@options[:project_root]}/config/lono.rb"
      @templates = []
      @results = {}
      @detected_format = nil
    end

    def run(options={})
      evaluate
      build
      output
    end

    def evaluate
      instance_eval(File.read(@path), @path)
      load_subfolder
      @detected_format = detect_format
    end

    # Detects the format of the templates.  Simply checks the extension of all the
    # templates files.
    # All the templates must be of the same format, either all json or all yaml.
    def detect_format
      # @templates contains Array of Hashes. Example:
      # [{name: ""blog-web-prod.json", block: ...},
      #  {name: ""api-web-prod.json", block: ...}]
      formats = @templates.map{ |t| File.extname(t[:name]) }.uniq
      if formats.size > 1
        puts "ERROR: Detected multiple formats: #{formats.join(", ")}".colorize(:red)
        puts "All the source values in the template blocks in the config folder must have the same format extension."
        exit 1
      else
        detected_format = formats.first.sub(/^\./,'')
        detected_format = "yaml" if detected_format == "yml"
      end
      detected_format
    end

    # load any templates defined in project/config/lono/*
    def load_subfolder
      Dir.glob("#{File.dirname(@path)}/lono/**/*").select{ |e| File.file? e }.each do |path|
        instance_eval(File.read(path), path)
      end
    end

    def template(name, &block)
      @templates << {name: name, block: block}
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
      puts "Generating CloudFormation templates:" unless @options[:quiet]
      @results.each do |name,text|
        path = "#{output_path}/#{name}"
        puts "  #{path}" unless @options[:quiet]
        ensure_parent_dir(path)
        validate(text, path)
        File.open(path, 'w') do |f|
          f.write(output_format(text))
        end
      end
    end

    # TODO: set @detected_format upon DSL.new
    def validate(text, path)
      if @detected_format == "json"
        validate_json(text, path)
      else
        validate_yaml(text, path)
      end
    end

    def validate_yaml(yaml, path)
      begin
        YAML.load(yaml)
      rescue Psych::SyntaxError => e
        puts "Invalid yaml.  Output written to #{path} for debugging".colorize(:red)
        puts "ERROR: #{e.message}".colorize(:red)
        File.open(path, 'w') {|f| f.write(yaml) }
        exit 1
      end
    end

    def validate_json(json, path)
      begin
        JSON.parse(json)
      rescue JSON::ParserError => e
        puts "Invalid json.  Output written to #{path} for debugging".colorize(:red)
        puts "ERROR: #{e.message}".colorize(:red)
        File.open(path, 'w') {|f| f.write(json) }
        exit 1
      end
    end

    def output_format(text)
      @options[:pretty] ? prettify(text) : text
    end

    # do not prettify yaml format because it removes the !Ref like CloudFormation notation
    def prettify(text)
      @detected_format == "json" ? JSON.pretty_generate(JSON.parse(text)) : text
    end

    def ensure_parent_dir(path)
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end
  end
end
