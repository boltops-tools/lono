module Lono
  class ProjectChecker
    # Checks to see command is running in a lono project.
    # If not, provide a friendly message and exit.
    def self.check(project_root)
      new(project_root).check
    end

    def initialize(project_root)
      @project_root = project_root
    end

    def check
      config_folder_exist
      templates_folder_exist
      empty_folders
    end

    def config_folder_exist
      unless File.exist?("#{@project_root}/config")
        puts "The config folder does not exist in this project.  Are you sure this is a lono project?"
        exit 1
      end
    end

    def templates_folder_exist
      unless File.exist?("#{@project_root}/templates")
        puts "The templates folder does not exist in this project.  Are you sure this is a lono project?"
        exit 1
      end
    end

    def empty_folders
      if Dir["#{@project_root}/config/**/*.rb"].empty?
        puts "The config folder does not contain any lono template definitions."
        exit 1
      end
      if Dir["#{@project_root}/templates/**/*"].empty?
        puts "The templates folder does not contain any lono template definitions."
        exit 1
      end
    end
  end
end
