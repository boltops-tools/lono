require "aws-sdk-s3"
require "filesize"

module Lono::Script
  class Upload
    def run
      return if Dir["#{Lono.root}/app/scripts/*"].empty?

      puts "Tarballing app/scripts folder to scripts.tgz"
      # puts "Uploading app/scripts to s3...".colorize(:green)
      sh "cd app && tar czf scripts.tgz scripts"
      path = "app/scripts.tgz"
      upload(path)
      FileUtils.rm_f(path)
      puts "Uploaded scripts.tz to s3: #{s3_dest}"
    end

    def upload(path)
      s3_info = s3_path.sub('s3://','').split('/')
      bucket_name = s3_info[0]
      key = s3_info[1..-1].join('/') + "/scripts.tgz"

      filesize = Filesize.from(File.size(path).to_s + " B").pretty
      puts "Uploading scripts.tgz (#{filesize}) to #{s3_dest}"

      start_time = Time.now
      obj = s3_resource.bucket(bucket_name).object(key)
      obj.upload_file(path)

      puts "Time to upload code to s3: #{pretty_time(Time.now-start_time).colorize(:green)}"
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

    def s3_resource
      @s3_resource ||= Aws::S3::Resource.new
    end

    # http://stackoverflow.com/questions/4175733/convert-duration-to-hoursminutesseconds-or-similar-in-rails-3-or-ruby
    def pretty_time(total_seconds)
      minutes = (total_seconds / 60) % 60
      seconds = total_seconds % 60
      if total_seconds < 60
        "#{seconds.to_i}s"
      else
        "#{minutes.to_i}m #{seconds.to_i}s"
      end
    end
  end
end
