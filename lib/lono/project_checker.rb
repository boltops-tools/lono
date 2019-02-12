# frozen_string_literal: true
module Lono
  # Checks to see command is running in a lono project.
  # If not, provide a friendly message and possibly exit.
  class ProjectChecker
    class << self
      # 2 ways to use lono.
      #
      #   1. A standalone project - not available below version 5
      #   2. A multimode project - available after version 5
      #
      @@checked = false
      def check
        return if @@checked

        unless standalone? or multimode?
          puts "ERROR: Was unable to detect that you are within a lono project. Are you sure you are in lono project?".color(:red)
          quit 1
        end

        @@mode = standalone? ? :standalone : :multimode

        @@checked = true
      end

      def mode
        @@mode
      end

      def standalone?
        paths = %w[
          app/definitions
          app/templates
        ]
        paths.all? do |path|
          File.exist?("#{Lono.root}/#{path}")
        end
      end

      def multimode?
        File.exist?("#{Lono.root}/configs/settings.yml")
      end

      # Dont exit for this one. It's okay. But show a warning.
      def empty_templates
        if Dir["#{Lono.config.templates_path}/**/*"].empty?
          puts "INFO: The app/templates folder does not contain any lono template definitions.".color(:yellow)
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
end
