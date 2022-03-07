class Lono::CLI::New
  class Hook < Lono::CLI::New::Sequence
    def self.cli_options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:blueprint, aliases: :b, desc: "Blueprint name. Only use you want a blueprint helper. Otherwise a project helper is generated"],
      ]
    end
    cli_options.each do |args|
      class_option(*args)
    end

    def set_source
      set_template_source "hook"
    end

    def create_hook
      logger.info "=> Generating hook"
      if blueprint
        directory ".", "app/blueprints/#{blueprint}"
      else
        directory ".", "."
      end
    end

  private
    # So templates/hooks/config/hooks.rb.tt has access to blueprint
    def blueprint
      @options[:blueprint]
    end
  end
end
