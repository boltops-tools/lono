module Lono::Script
  class Upload
    def initialize(options)
      @options = options
    end

    def run
      return if Dir["#{Lono.root}/app/scripts/*"].empty?

      puts "Uploading app/scripts to s3...".colorize(:green)
      sh "aws s3 sync app/scripts #{s3_dest}"
      puts "Uploaded app/scripts to s3."
    end

    def sh(command)
      puts "=> #{command}"
      system command
    end

    # ensures s3:// is added and that it goes under the scripts subfolder.
    def s3_dest
      dest = s3_path.include?("s3://") ? s3_path : "s3://#{s3_path}"
      "#{dest}/#{Lono.env}/scripts"
    end

    def s3_path
      setting = Lono::Setting.new
      setting.s3_path
    end
  end
end
