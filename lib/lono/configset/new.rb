class Lono::Configset
  class New < Lono::Sequence
    include Lono::Blueprint::Helper

    argument :configset_name

    def self.source_root
      templates = File.expand_path("../../templates", File.dirname(__FILE__))
      "#{templates}/configset"
    end

    def self.cli_options
      [
        [:demo, type: :boolean, default: true, desc: "Include demo template"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
      ]
    end

    cli_options.each do |args|
      class_option(*args)
    end

    # for specs
    def set_cwd
      @cwd = ENV['LONO_TEST'] ? File.dirname(Lono.root) : "#{Dir.pwd}/app/configsets"
    end

    def set_variables
      @demo = @options[:demo]
      @demo = false if ENV["LONO_ORG"] # overrides --demo CLI option
    end

    def create_project
      puts "=> Creating new configset called #{configset_name}."
      if @demo
        options = {}
      else
        create_file "#{@cwd}/#{configset_name}/lib/configset.yml"
        options = {exclude_pattern: %r{configset\.yml}}
      end

      directory ".", "#{@cwd}/#{configset_name}", options
    end

    def create_license
      return unless ENV['LONO_LICENSE_FILE']
      copy_file ENV['LONO_LICENSE_FILE'], "#{@cwd}/#{configset_name}/LICENSE.txt"
    end

    # After this commands are executed with the newly created project
    def set_destination_root
      destination_root = "#{@cwd}/#{configset_name}"
      self.destination_root = destination_root
      @old_dir = Dir.pwd # for reset_current_dir
      FileUtils.cd(self.destination_root)
    end

    def welcome_message
      puts <<~EOL
        #{"="*64}
        Congrats 🎉 You have successfully created a lono configset.

        Cd into your configset and check things out.

            cd #{configset_name}

        More info: https://lono.cloud/docs/core/configsets

      EOL
    end

    def tree
      tree_installed = system("type tree > /dev/null")
      return unless tree_installed

      structure = `tree .`
      puts <<~EOL
        Here is the structure of your configset:

        #{structure}
      EOL
    end
  end
end
