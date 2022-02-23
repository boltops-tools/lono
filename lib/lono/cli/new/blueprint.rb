class Lono::CLI::New
  class Blueprint < Sequence
    argument :name
    def self.cli_options
      [
        [:examples, type: :boolean, desc: "Whether not to generate examples"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:project, desc: "Project name"],
      ]
    end
    cli_options.each do |args|
      class_option(*args)
    end

    def set_source
      if @options[:examples]
        set_template_source "examples/blueprint"
      else
        set_template_source "blueprint"
      end
    end

    def create_blueprint
      logger.info "=> Creating new blueprint called #{name}."
      dest = [@options[:project], "app/blueprints"].compact.join('/')
      directory ".", "#{dest}/#{name}"
    end
  end
end
