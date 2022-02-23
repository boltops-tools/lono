class Lono::CLI::New::Helper
  class Blueprint < Lono::CLI::New::Sequence
    def self.cli_options
      # required for name => underscore_name => app/blueprints/demo/helpers/%underscore_name%_helper.rb.tt
      argument :name, default: "custom", desc: "Helper name"

      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:blueprint, required: true, desc: "Blueprint name"],
      ]
    end
    cli_options.each do |args|
      class_option(*args)
    end

    def set_source
      set_template_source "helper"
    end

    def create_blueprint
      @blueprint = @options[:blueprint] # allows %underscore_name%_helper.rb.tt to access @blueprint
      logger.info "=> Generating #{underscore_name}_helper.rb"
      directory ".", "app/blueprints/#{@blueprint}/helpers"
    end
  end
end
