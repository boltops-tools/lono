class Lono::ProjectChecker
    # Checks to see command is running in a lono project.
  # If not, provide a friendly message and exit.
  def self.check
    new.check
  end

  def check
    config_folder_exist
    templates_folder_exist
    empty_folders
  end

  def config_folder_exist
    unless File.exist?("#{Lono.root}/config")
      puts "The config folder does not exist in this project.  Are you sure this is a lono project?"
      quit
    end
  end

  def templates_folder_exist
    unless File.exist?("#{Lono.root}/templates")
      puts "The templates folder does not exist in this project.  Are you sure this is a lono project?"
      quit
    end
  end

  def empty_folders
    if Dir["#{Lono.root}/config/**/*.rb"].empty?
      puts "The config folder does not contain any lono template definitions."
      quit
    end
    if Dir["#{Lono.root}/templates/**/*"].empty?
      puts "The templates folder does not contain any lono template definitions."
      quit
    end
  end

  def quit
    if ENV['TEST'] == '1'
      raise("Not in lono project")
    else
      exit 1
    end
  end
end
