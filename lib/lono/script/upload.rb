require "aws-sdk-s3"
require "filesize"

class Lono::Script
  class Upload < Base
    def run
      Lono::ProjectChecker.check
      return unless scripts_built?

      upload(tarball_path)
      puts "Uploaded #{File.basename(s3_dest)} to s3."
    end

    def upload(tarball_path)
      puts "Uploading scripts.tgz (#{filesize}) to #{s3_dest}"
      obj = s3_resource.bucket(bucket_name).object(key)
      start_time = Time.now
      obj.upload_file(tarball_path)
      time_took = pretty_time(Time.now-start_time).colorize(:green)
      puts "Time to upload code to s3: #{time_took}"
    end

    def filesize
      Filesize.from(File.size(tarball_path).to_s + " B").pretty
    end

    def s3_dest
      "s3://#{bucket_name}/#{key}"
    end

    def key
      # Example key: cloudformation/development/scripts/scripts-md5
      "#{dest_folder}/#{File.basename(tarball_path)}"
    end

    # Example:
    #   s3_folder: s3://infra-bucket/cloudformation
    #   bucket_name: infra-bucket
    def bucket_name
      s3_folder.sub('s3://','').split('/').first
    end

    # Removes s3://bucket-name and adds Lono.env. Example:
    #   s3_folder: s3://infra-bucket/cloudformation
    #   bucket_name: cloudformation/development/scripts
    def dest_folder
      folder = s3_folder.sub('s3://','').split('/')[1..-1].join('/')
      "#{folder}/#{Lono.env}/scripts"
    end

    # Scripts are only built if the app/scripts folder is non empty
    def scripts_built?
      File.exist?(SCRIPTS_INFO_PATH) && !tarball_path.empty?
    end

    def tarball_path
      IO.read(SCRIPTS_INFO_PATH).strip
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
