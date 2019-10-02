require 'fileutils'
require 'yaml'

class Lono::Upgrade
  class Upgrade5 < Lono::Sequence
    def sanity_check
      if File.exist?("blueprints")
        puts "The blueprints folder already exist. The project already seems to have the lono v5 structure."
        exit
      end

      unless File.exist?("config/settings.yml")
        puts "ERROR: The config/settings.yml file does not exist. Are you sure you're within a lono project?".color(:red)
        exit 1
      end
    end

    def create_blueprints_folder
      puts "Creating: blueprints folder"
      FileUtils.mkdir_p("blueprints/main")
    end

    def move_to_main_blueprint
      puts "Moving files to blueprints folder"
      # Dir.entries includes hidden files
      Dir.entries('.').each do |p|
        next if %w[blueprints .git .. .].include?(p)
        FileUtils.mv(p, "blueprints/main/#{p}")
      end
    end

    def move_configs
      puts "Setting up the new configs structure"
      FileUtils.mkdir_p("configs/main")
      FileUtils.mv("blueprints/main/config/params", "configs/main/params")
      FileUtils.mv("blueprints/main/config/variables", "configs/main/variables")
      FileUtils.mv("blueprints/main/config/settings.yml", "configs/settings.yml")

      FileUtils.rmdir("blueprints/main/config") if Dir.empty?("blueprints/main/config")
    end

    def starter_files
      puts "Creating remaining starter lono project files"
      files = %w[
        .gitignore
        Gemfile
        Guardfile
        README.md
      ]
      files.each { |f | template(f) }

      template("../upgrade5/blueprints/main/.meta/config.yml", "blueprints/main/.meta/config.yml")
    end
  end
end
