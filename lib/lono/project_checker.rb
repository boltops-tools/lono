# Checks to see command is running in a lono project.
# If not, provide a friendly message and exit.
class Lono::ProjectChecker
  class << self
    def check
      check_lono_project
    end

    def check_lono_project
      paths = %w[
        config/settings.yml
        app/definitions
        app/templates
      ]
      paths.each do |path|
        unless File.exist?("#{Lono.root}/#{path}")
          puts "ERROR: The #{path} does not exist in this project.  Are you sure you are in lono project?".colorize(:red)
          quit 1
        end
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
