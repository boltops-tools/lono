require "thor"

module Lono::AppFile
  class Build < Base
    def initialize_variables
      @output_files_path = "#{Lono.config.output_path}/#{@blueprint}/files"
    end

    def run
      return unless detect_files?
      puts "Building app/files for blueprint #{@blueprint}"
      build_all
    end

    def build_all
      clean_output
      copy_to_output
      Registry.items.each do |item|
        if item.directory?
          zip_directory(item)
        elsif item.file?
          zip_file(item)
        else
          puts "WARN: #{item.path} does not exist. Double check that the path is correct in the s3_key call.".color(:yellow)
        end
      end
    end

    def copy_to_output
      override_source_paths("#{Lono.blueprint_root}/app/files")
      self.destination_root = @output_files_path
      directory(".", verbose: false, context: context.get_binding) # Thor::Action
    end

    def context
      Lono::Template::Context.new(@options)
    end
    memoize :context

    def zip_file(item)
      path = item.path
      zip_file = item.zip_file_name

      puts "Zipping file and generating md5 named file from: #{path}"
      command = "cd #{File.dirname(path)} && zip -q #{zip_file} #{File.basename(path)}" # create zipfile at same level of file
      zip(command)
    end

    def zip_directory(item)
      path = item.path
      zip_file = item.zip_file_name

      puts "Zipping folder and generating md5 named file from: #{path}"
      command = "cd #{path} && zip --symlinks -rq #{zip_file} ." # create zipfile witih directory
      zip(command)
      FileUtils.mv("#{path}/#{zip_file}", "#{File.dirname(path)}/#{zip_file}") # move zip back to the parent directory
    end

    def zip(command)
      # puts "=> #{command}".color(:green) # uncomment to debug
      `#{command}`
      unless $?.success?
        puts "ERROR: Fail to run #{command}".color(:red)
        puts "Maybe zip is not installed or path is incorrect?"
        exit 1
      end
    end

    def clean_output
      FileUtils.rm_rf(@output_files_path)
    end

    def detect_files?
      app_files = Dir["#{Lono.blueprint_root}/app/files/*"]
      if app_files.empty?
        false
      else
        puts "Detected app/files for blueprint #{@blueprint}"
        true
      end
    end
  end
end
