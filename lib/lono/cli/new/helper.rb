class Lono::CLI::New
  class Helper < Sequence
    def self.cli_options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:blueprint, required: true, desc: "Blueprint name"],
        [:name, default: "custom", desc: "Helper name"],
      ]
    end
    cli_options.each do |args|
      class_option(*args)
    end

    def set_source
      set_template_source "helper"
    end

    def set_vars
      @blueprint = @options[:blueprint]
      @name = @options[:name]
    end

    def create_blueprint
      puts "underscore_name #{underscore_name}"
      logger.info "=> Generating helper: #{@name}"
      directory ".", "app/blueprints/#{@blueprint}/helpers"
    end

  private
    attr_reader :name # required for templates/helper/%name%_helper.rb.tt
  end
end
