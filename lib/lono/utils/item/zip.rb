require 'fileutils'

module Lono::Utils::Item
  module Zip
    def zip(item)
      if item.directory?
        zip_directory(item)
      else
        zip_file(item)
      end
    end

    def zip_file(item)
      path = item.output_path
      zip_file = item.zip_file_name

      puts "Zipping file and generating md5 named file from: #{path}"
      command = "cd #{File.dirname(path)} && zip -q #{zip_file} #{File.basename(path)}" # create zipfile at same level of file
      execute_zip(command)
    end

    def zip_directory(item)
      path = item.output_path
      zip_file = item.zip_file_name

      puts "Zipping folder and generating md5 named file from: #{path}"
      command = "cd #{path} && zip --symlinks -rq #{zip_file} ." # create zipfile witih directory
      execute_zip(command)
      FileUtils.mv("#{path}/#{zip_file}", "#{File.dirname(path)}/#{zip_file}") # move zip back to the parent directory
    end

    def execute_zip(command)
      # puts "=> #{command}".color(:green) # uncomment to debug
      `#{command}`
      unless $?.success?
        puts "ERROR: Fail to run #{command}".color(:red)
        puts "Maybe zip is not installed or path is incorrect?"
        exit 1
      end
    end
  end
end
