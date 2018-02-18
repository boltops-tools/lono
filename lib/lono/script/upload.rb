require "aws-sdk-s3"
require "filesize"
require "digest"

module Lono::Script
  class Upload
    def run
      return if Dir["#{Lono.root}/app/scripts/*"].empty?

      tarball_path = create_tarball
      s3_dest = upload(tarball_path)
      # FileUtils.rm_f(path)
      puts "EXITING!"
      exit
      puts "Uploaded #{File.basename(s3_dest)} to s3: #{s3_dest}"
    end

    def create_tarball
      puts "Tarballing app/scripts folder to scripts.tgz"
      # https://apple.stackexchange.com/questions/14980/why-are-dot-underscore-files-created-and-how-can-i-avoid-them
      sh "cd app && dot_clean ." if system("type dot_clean > /dev/null")

      # first create a temporary app/scripts.tgz file
      sh "cd app && tar czf scripts.tgz scripts"

      rename_with_md5!("app/scripts.tgz")
    end

    # Apppend a time and md5 to file after it's been created
    def rename_with_md5!(path)
      md5 = Digest::MD5.file(path).to_s[0..7]
      time = Time.now.strftime("%F")
      md5_path = path.sub(".tgz", "#{time}-#{md5}.tgz")
      FileUtils.mv(path, md5_path)
      md5_path
    end

    # ensures s3:// and Lono.env is added
    def s3_dest_folder
      dest = s3_path.include?("s3://") ? s3_path : "s3://#{s3_path}"
      "#{dest}/#{Lono.env}/scripts"
    end

    # Variable values examples:
    #
    #   s3_dest_folder: s3://infra-bucket/cloudformation/development/scripts
    #   bucket_name: infra-bucket
    #   folder: cloudformation/development/scripts
    def upload(tarball_path)
      s3_info = s3_dest_folder.sub('s3://','').split('/')
      bucket_name = s3_info[0]
      folder = s3_info[1..-1].join('/')
      key = "#{folder}/#{File.basename(tarball_path)}"
      obj = s3_resource.bucket(bucket_name).object(key)

      puts "bucket_name #{bucket_name}"
      puts "folder #{folder}"
      puts "key #{key}"

      filesize = Filesize.from(File.size(tarball_path).to_s + " B").pretty
      puts "Uploading scripts.tgz (#{filesize}) to #{s3_dest}"
      start_time = Time.now
      obj.upload_file(path)
      puts "Time to upload code to s3: #{pretty_time(Time.now-start_time).colorize(:green)}"
    end

    def sh(command)
      puts "=> #{command}"
      system command
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
