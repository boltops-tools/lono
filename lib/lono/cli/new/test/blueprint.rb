class Lono::CLI::New::Test
  class Blueprint < Sequence
    argument :name

    def self.cli_options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
      ]
    end
    cli_options.each { |args| class_option(*args) }

    def set_source
      name = Lono.config.test.framework
      framework = Lono::Plugin.find(name: name, type: "test_framework")
      set_template_paths("#{framework.root}/lib/templates/blueprint")
    end

    def generate
      dest = "app/blueprints/#{name}"
      directory ".", dest
    end
  end
end
