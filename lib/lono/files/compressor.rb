require 'fileutils'

class Lono::Files
  class Compressor < Base
    def run
      if File.directory?(output_path)
        zip_directory
      else
        zip_file
      end
    end

    def zip_file
      logger.debug "Zipping file to #{pretty_path(zip_path)}"
      # create zipfile at same level of file
      command = "cd #{File.dirname(output_path)} && zip -q #{zip_name} #{File.basename(output_path)}"
      execute_zip(command)
    end

    def zip_directory
      logger.debug "Zipping folder to #{zip_path}"
      command = "cd #{output_path} && zip --symlinks -rq #{zip_name} ." # create zipfile witih directory
      execute_zip(command)
      FileUtils.mv("#{output_path}/#{zip_name}", "#{File.dirname(output_path)}/#{zip_name}") # move zip back to the parent directory
    end

  private
    def execute_zip(command)
      check_zip_installed!
      logger.debug "=> #{command}".color(:green)
      `#{command}`
      return if $?.success?
      logger.info "ERROR: Fail trying to zip files".color(:red)
      logger.info "Command: #{command}".color(:red)
      exit 1
    end

    @@zip_installed = false
    def check_zip_installed!
      @@zip_installed = system("type zip > /dev/null 2>&1")
      if @@zip_installed
        @@zip_installed = true
        return
      end
      logger.error "ERROR: The command 'zip' is not installed.".color(:red)
      logger.error <<~EOL
        The file helper requires the zip command.
        Please install the zip command on this system.
      EOL
      exit 1
    end
  end
end
