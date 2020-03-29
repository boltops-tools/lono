class Lono::Blueprint
  class New < Lono::Sequence
    include Helper
    include Lono::Utils::Generators::Tree

    argument :blueprint_name

    def self.source_root
      templates = File.expand_path("../../templates", File.dirname(__FILE__))
      "#{templates}/blueprint"
    end

    def self.cli_options
      [
        [:bundle, type: :boolean, default: true, desc: "Runs bundle install on the project"],
        [:demo, type: :boolean, default: true, desc: "Include demo template"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:from_new, type: :boolean, desc: "Called from `lono new` command."],
        [:import, type: :boolean, desc: "Flag for lono code import"],
        [:project_name, default: '', desc: "Only used with from_new internally"],
        [:type, default: "dsl", desc: "Blueprint type: dsl or erb"],
      ]
    end

    cli_options.each do |args|
      class_option(*args)
    end

    # for specs
    def set_cwd
      @cwd = "#{Lono.root}/app/blueprints"

      if options[:from_new]
        # At this point @cwd will have the project_name from `lono new`
        # Yup, it's confusing.  Here's an example to explain:
        #
        #   lono new my-infra - sets @cwd = my-infra
        #
        # Then within the new Thor::Group this is called
        #
        #   Lono::Blueprint::New.start(["ec2", "--from-new"])
        #
        # So @cwd = my-infra/blueprints
        @cwd = "#{options[:project_name]}/app/blueprints"
      end
    end

    def set_variables
      @demo = @options[:demo]
      @demo = false if ENV["LONO_ORG"] # overrides --demo CLI option
    end

    def create_project
      puts "=> Creating new blueprint called #{blueprint_name}."
      directory ".", "#{@cwd}/#{blueprint_name}"
    end

    def create_app_folder
      return if @options[:import]

      if @demo
        directory "../blueprint_types/#{@options[:type]}", "#{@cwd}/#{blueprint_name}"
      else
        empty_directory "#{@cwd}/#{blueprint_name}/app/templates"
        create_file "#{@cwd}/#{blueprint_name}/app/templates/#{blueprint_name}.rb"
      end
    end

    def create_empty_directories
      # Note: Not using Lono::Core::Config::PATHS.keys to create all of them because
      # think it is more common to not have all the folders. Instead create them explicitly.
      empty_directory "#{@cwd}/#{blueprint_name}/app/templates"
    end

    def create_starter_configs
      return unless @demo
      return if @options[:import]

      if options[:from_new] # lono new command
        directory "../blueprint_configs", options[:project_name]
      else # lono blueprint new command
        directory "../blueprint_configs", "."
      end
    end

    def create_license
      return unless ENV['LONO_LICENSE_FILE']
      copy_file ENV['LONO_LICENSE_FILE'], "#{@cwd}/#{blueprint_name}/LICENSE.txt"
    end

    # After this commands are executed with the newly created project
    def set_destination_root
      destination_root = "#{@cwd}/#{blueprint_name}"
      self.destination_root = destination_root
      @old_dir = Dir.pwd # for reset_current_dir
      FileUtils.cd(self.destination_root)
    end

    def welcome_message
      return if options[:from_new] || options[:import]
      puts <<~EOL
        #{"="*64}
        Congrats 🎉 You have successfully created a lono blueprint.

        Cd into your blueprint and check things out.

            cd #{blueprint_name}

        More info: https://lono.cloud/docs/core/blueprints

      EOL
    end

    def tree
      tree_structure("blueprint")
    end

    # Reason: So `lono code import` prints out the params values with relative paths
    # when the config files are generated.
    def reset_current_dir
      FileUtils.cd(@old_dir)
    end
  end
end
