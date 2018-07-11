require 'fileutils'
require 'yaml'

class Lono::Upgrade
  class Upgrade42 < Lono::Sequence
    def upsert_gitignore
      text =<<-EOL
.lono/current
EOL
      if File.exist?(".gitignore")
        append_to_file ".gitignore", text
      else
        create_file ".gitignore", text
      end
    end

    def update_settings_yaml
      path = "config/settings.yml"
      puts "Updating #{path}."
      data = YAML.load_file(path)

      if data["base"].has_key?("randomize_stack_name")
        randomize = data["base"]["randomize_stack_name"]
        if randomize
          data["base"]["stack_name_suffix"] = "random"
        end

        data["base"].delete("randomize_stack_name")
        puts "Updated randomize_stack_name with stack_name_suffix."
      end

      text = YAML.dump(data)
      IO.write(path, text)
    end
  end
end
