require "aws-sdk-s3"
require "filesize"

module Lono::Script
  class Upload < Base
    def run
      return unless scripts_built?

      s3_dest = upload(tarball_path)
      puts "Uploaded #{File.basename(s3_dest)} to s3: #{s3_dest}"
    end

    def upload(tarball_path)
      # Example key: cloudformation/development/scripts/scripts-md5
      key = "#{dest_folder}/#{File.basename(tarball_path)}"
      obj = s3_resource.bucket(bucket_name).object(key)

      puts "bucket_name #{bucket_name}"
      puts "dest_folder #{dest_folder}"
      puts "key #{key}"

      puts "Uploading scripts.tgz (#{filesize}) to #{s3_dest}"
      start_time = Time.now
      obj.upload_file(tarball_path)
      time_took = pretty_time(Time.now-start_time).colorize(:green)
      puts "Time to upload code to s3: #{time_took}"
    end

    def filesize
      Filesize.from(File.size(tarball_path).to_s + " B").pretty
    end

    def tarball_path
      IO.read(@scripts_name_path).strip
    end

    # Example:
    #   s3_folder: s3://infra-bucket/cloudformation
    #   bucket_name: infra-bucket
    def bucket_name
      s3_folder.sub('s3://','').split('/').first
    end

    # Removes s3:// and adds Lono.env. Example:
    #   s3_folder: s3://infra-bucket/cloudformation
    #   bucket_name: cloudformation/development/scripts
    def dest_folder
      folder = s3_folder.sub('s3://','')
      "#{folder}/#{Lono.env}/scripts"
    end

    def scripts_built?
      File.exist?(@scripts_name_path) && tarball_path.empty?
    end

    # s3_folder example:
    def s3_folder
      setting = Lono::Setting.new
      setting.s3_folder
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
