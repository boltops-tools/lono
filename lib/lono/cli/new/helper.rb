class Lono::CLI::New
  class Helper < Lono::CLI::New::Sequence
    def self.cli_options
      # required for name => underscore_name => app/blueprints/demo/helpers/%underscore_name%_helper.rb.tt
      argument :name, default: "custom", desc: "Helper name"

      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:blueprint, aliases: :b, desc: "Blueprint name. Only use you want a blueprint helper. Otherwise a project helper is generated"],
      ]
    end
    cli_options.each do |args|
      class_option(*args)
    end

    def set_source
      set_template_source "helper"
    end

    def create_helper
      if @options[:blueprint]
        create_blueprint_helper
      else
        create_project_helper
      end
    end

  private
    def create_blueprint_helper
      @blueprint = @options[:blueprint] # allows %underscore_name%_helper.rb.tt to access @blueprint
      logger.info "=> Generating #{underscore_name}_helper.rb"
      directory ".", "app/blueprints/#{@blueprint}/helpers"
    end

    def create_project_helper
      logger.info "=> Generating #{underscore_name}_helper.rb"
      directory ".", "app/helpers/#{underscore_name}"
    end
  end
end
