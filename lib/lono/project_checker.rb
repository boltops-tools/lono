# Checks to see command is running in a lono project.
# If not, provide a friendly message and exit.
class Lono::ProjectChecker
  class << self
    def check
      check_lono_project
    end

    def check_lono_project
      unless File.exist?("#{Lono.root}/config/settings.yml")
        puts "ERROR: The config/settings.yml file does not exist in this project.  Are you sure this is a lono project?".colorize(:red)
        quit 1
      end
    end

    # Dont exit for this one. It's okay. But show a warning.
    def empty_templates
      if Dir["#{Lono.config.templates_path}/**/*"].empty?
        puts "INFO: The app/templates folder does not contain any lono template definitions.".colorize(:yellow)
      end
    end

    def quit(signal)
      if ENV['TEST'] == '1'
        signal == 0 || raise("Not in lono project")
      else
        exit(signal)
      end
    end
  end
end
