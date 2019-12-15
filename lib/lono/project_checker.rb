# frozen_string_literal: true
module Lono
  # Checks to see command is running in a lono project.
  # If not, provide a friendly message and possibly exit.
  class ProjectChecker
    class << self
      @@checked = false
      def check
        return if @@checked

        unless File.exist?("#{Lono.root}/configs/settings.yml")
          puts "ERROR: Could not find configs/settings.yml file. Are you sure you are in lono project?".color(:red)
          quit 1
        end

        @@checked = true
      end

      # Dont exit for this one. It's okay. But show a warning.
      def empty_templates
        if Dir["#{Lono.config.templates_path}/**/*"].empty?
          puts "INFO: The app/templates folder does not contain any lono template definitions.".color(:yellow)
        end
      end

      def quit(signal)
        if ENV['LONO_TEST'] == '1'
          signal == 0 || raise("Not in lono project. pwd: #{Dir.pwd}")
        else
          exit(signal)
        end
      end
    end
  end
end
