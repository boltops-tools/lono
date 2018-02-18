module Lono::Script
  class Upload
    def run
      return if Dir["#{Lono.root}/app/scripts/*"].empty?

      puts "Tarballing app/scripts folder to scripts.tgz"
      # puts "Uploading app/scripts to s3...".colorize(:green)
      sh "cd app && tar czf scripts.tgz scripts"
      # TODO: use ruby aws-sdk to upload instead of aws s3 sync
      sh "aws s3 cp app/scripts.tgz #{s3_dest}"
      FileUtils.rm_f("app/scripts.tgz")
      puts "Uploaded scripts.tz to s3: #{s3_dest}"
    end

    def sh(command)
      puts "=> #{command}"
      system command
    end

    # ensures s3:// is added and that it goes under the scripts subfolder.
    def s3_dest
      dest = s3_path.include?("s3://") ? s3_path : "s3://#{s3_path}"
      "#{dest}/#{Lono.env}/scripts.tgz"
    end

    def s3_path
      setting = Lono::Setting.new
      setting.s3_path
    end
  end
end
