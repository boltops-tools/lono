class Lono::Extension
  class New < Lono::Sequence
    include Lono::Blueprint::Helper # for user_info
    include Lono::Extension::Helper

    argument :extension_name

    def self.source_root
      templates = File.expand_path("../../templates", File.dirname(__FILE__))
      "#{templates}/extension"
    end

    def self.cli_options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
      ]
    end

    cli_options.each do |args|
      class_option(*args)
    end

    # for specs
    def set_cwd
      @cwd = ENV['LONO_TEST'] ? File.dirname(Lono.root) : "#{Dir.pwd}/app/extensions"
    end

    def create_project
      puts "=> Creating new extension called #{extension_name}."
      directory ".", "#{@cwd}/#{extension_name}", options
    end

    def create_license
      return unless ENV['LONO_LICENSE_FILE']
      copy_file ENV['LONO_LICENSE_FILE'], "#{@cwd}/#{extension_name}/LICENSE.txt"
    end

    # After this commands are executed with the newly created project
    def set_destination_root
      destination_root = "#{@cwd}/#{extension_name}"
      self.destination_root = destination_root
      @old_dir = Dir.pwd # for reset_current_dir
      FileUtils.cd(self.destination_root)
    end

    def welcome_message
      puts <<~EOL
        #{"="*64}
        Congrats 🎉 You have successfully created a lono extension.

        Cd into your extension and check things out.

            cd #{extension_name}

        More info: https://lono.cloud/docs/extensions

      EOL
    end

    def tree
      tree_installed = system("type tree > /dev/null")
      return unless tree_installed

      structure = `tree .`
      puts <<~EOL
        Here is the structure of your extension:

        #{structure}
      EOL
    end
  end
end
