module Lono::Template::Strategy
  class Erb < Base
    include Lono::Template::Evaluate
    include Lono::Template::Util

    def initialize(options={})
      super
      @templates = []
      @results = {}
    end

    def run(options={})
      evaluate_templates
      build_templates
      write_output
    end

    # Instance eval's the template declarations in app/definitions in this order:
    #
    #   app/definitions/base.rb
    #   app/definitions/base - all files in folder
    #   app/definitions/[Lono.env].rb
    #   app/definitions/[Lono.env] - all files in folder
    #
    # So Lono.env specific template declarations override base template declarations.
    def evaluate_templates
      evaluate_template("base")
      evaluate_folder("base")
      evaluate_template(Lono.env)
      evaluate_folder(Lono.env)
    end

    def evaluate_template(name)
      path = "#{Lono.config.definitions_path}/#{name}.rb"
      evaluate_template_path(path)
    end

    def evaluate_folder(folder)
      paths = Dir.glob("#{Lono.config.definitions_path}/#{folder}/**/*")
      paths.select{ |e| File.file?(e) }.each do |path|
        evaluate_template_path(path)
      end
    end

    def template(name, &block)
      @templates << {name: name, block: block}
    end

    def build_templates
      @templates.each do |t|
        @results[t[:name]] = Lono::Template::Template.new(@blueprint, t[:name], t[:block], @options).build
      end
    end

    def write_output
      output_path = "#{Lono.config.output_path}/#{@blueprint}/templates"
      FileUtils.rm_rf(Lono.config.output_path) if @options[:clean] # removes entire output folder. params and templates
      FileUtils.mkdir_p(output_path)
      puts "Generating CloudFormation templates for blueprint #{@blueprint.color(:green)}:" unless @options[:quiet]
      @results.each do |name,text|
        path = "#{output_path}/#{name}".sub(/^\.\//,'') # strip leading '.'
        path += ".yml"
        unless @options[:quiet]
          pretty_path = path.sub("#{Lono.root}/",'')
          puts "  #{pretty_path}"
        end
        ensure_parent_dir(path)
        text = commented(text)
        IO.write(path, text) # write file first so validate method is simpler
        Lono::Yamler::Validator.new(path).validate!
      end
    end

    def commented(text)
      comment =<<~EOS
        # This file was generated with lono. Do not edit directly, the changes will be lost.
        # More info: http://lono.cloud
      EOS
      "#{comment}#{text}"
    end
  end
end