class Lono::Importer
  class Base < Lono::AbstractBase
    include Download
    include Thor::Actions
    include Thor::Base

    def initialize(options)
      reinitialize(options)
      @source = options[:source]
      @tmp_path = "/tmp/lono/import/template.yml"
      self.destination_root = Dir.pwd # Thor::Actions require destination_root to be set
    end

  private
    def summarize
      return unless @options[:summary]
      puts "Template Summary:"
      Lono::Inspector::Summary.new(@options).run
    end

    def create_params(template_path)
      create_params_file(template_path, "development")
      create_params_file(template_path, "production")
    end

    def create_params_file(template_path, env)
      params_path = if @blueprint != @template
                      "configs/#{@blueprint}/params/#{env}/#{@template}.txt"
                    else
                      "configs/#{@blueprint}/params/#{env}.txt"
                    end
      params = Params.new(template_path, params_path)
      params.create
    end

    # removes the ./ at the beginning if it's there in the path
    def pretty_path(path)
      path.sub("#{Lono.root}/",'')
    end

    def create_dot_lono(type)
      dot_lono = "#{Lono.blueprint_root}/.meta"
      FileUtils.mkdir_p(dot_lono)
      config = {
        "blueprint_name" => @blueprint,
        "template_type" => "#{type}",
      }
      text = YAML.dump(config)
      IO.write("#{dot_lono}/config.yml", text)
    end

    def blueprint_name
      return @options[:name] if @options[:name]
      # Else infer name from the original source.
      name = File.basename(@source, ".*")
      @options[:casing] == "camelcase" ? name.camelize : name.underscore.dasherize
    end
  end
end
