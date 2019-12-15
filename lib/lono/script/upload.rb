require "filesize"

class Lono::Script
  class Upload < Base
    include Lono::AwsServices
    include Lono::Utils::PrettyTime

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
      time_took = pretty_time(Time.now-start_time).color(:green)
      puts "Time took to upload code to s3: #{time_took}"
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

    def bucket_name
      Lono::S3::Bucket.name
    end

    def dest_folder
      "#{Lono.env}/scripts"
    end

    # Scripts are only built if the app/scripts folder is non empty
    def scripts_built?
      File.exist?(SCRIPTS_INFO_PATH) && !tarball_path.empty?
    end

    def tarball_path
      IO.read(SCRIPTS_INFO_PATH).strip
    end
  end
end
