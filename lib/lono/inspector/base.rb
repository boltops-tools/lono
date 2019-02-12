class Lono::Inspector::Base
  include Lono::Blueprint::Root

  def initialize(blueprint, template, options)
    @blueprint, @template, @options = blueprint, template, options
  end

  def run
    blueprints = Lono::Blueprint::Find.one_or_all(@blueprint)
    blueprints.each do |blueprint|
      @blueprint_name = blueprint

      generate_templates
      set_blueprint_root(blueprint)
      templates = @template ? [@template] : all_templates
      templates.each do |template_name|
        perform(template_name)
      end
    end
  end

  def generate_templates
    Lono::Template::Generator.new(@blueprint_name, @options.clone.merge(quiet: false)).run
  end

  def all_templates
    templates_path = "#{Lono.config.output_path}/#{@blueprint_name}/templates"
    Dir.glob("#{templates_path}/**").map do |path|
      path.sub("#{templates_path}/", '').sub('.yml','') # template_name
    end
  end

  def data
    template_path = "#{Lono.config.output_path}/#{@blueprint_name}/templates/#{@template_name}.yml"
    check_template_exists(template_path)
    YAML.load(IO.read(template_path))
  end

  # Check if the template exists and print friendly error message.  Exits if it
  # does not exist.
  def check_template_exists(template_path)
    unless File.exist?(template_path)
      puts "The template #{template_path} does not exist. Are you sure you use the right template name?  The template name does not require the extension.".color(:red)
      exit 1
    end
  end

end
