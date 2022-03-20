class Lono::CLI::New
  class Configset < Sequence
    argument :name
    def self.cli_options
      [
        [:examples, type: :boolean, desc: "Whether not to generate examples"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
      ]
    end
    cli_options.each do |args|
      class_option(*args)
    end

    def set_source
      if @options[:examples]
        set_template_source "examples/configset"
      else
        set_template_source "configset"
      end
    end

    def create_configset
      dest = "#{Lono.root}/app/configsets"
      directory ".", "#{dest}/#{name}"
    end

    def welcome_message
      puts <<~EOL
        #{"="*64}
        Congrats 🎉 You have successfully created a lono configset.

        More info: https://lono.cloud/docs/configsets

      EOL
    end
  end
end
