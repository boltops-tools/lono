require "digest"
require "fileutils"

module Lono::Script
  class Build < Base
    # Only avaialble after script has been built.
    def self.scripts_name
      new.scripts_name
    end

    def initialize(options)
      @options = options
      @scripts_name_path = "#{Lono.config.output_path}/data/scripts_name.txt"
    end

    def run
      reset
      return if Dir["#{Lono.root}/app/scripts/*"].empty?

      tarball_path = create_tarball
      save_scripts_name(File.basename(tarball_path))
    end

    # Only avaialble after script has been built.
    def scripts_name
      IO.read(@scripts_name_path).strip
    end

    def reset
      FileUtils.rm_f(@scripts_name_path)
    end

    def create_tarball
      puts "Tarballing app/scripts folder to scripts.tgz"
      # https://apple.stackexchange.com/questions/14980/why-are-dot-underscore-files-created-and-how-can-i-avoid-them
      sh "cd app && dot_clean ." if system("type dot_clean > /dev/null")

      # first create a temporary app/scripts.tgz file
      sh "cd app && tar czf scripts.tgz scripts"

      rename_with_md5!
    end

    # Apppend a md5 to file after it's been created and moves it to
    # output/scripts/scripts-[MD5].tgz
    def rename_with_md5!
      md5_path = "output/scripts/scripts-#{md5sum}.tgz"
      FileUtils.mkdir_p(File.dirname(md5_path))
      FileUtils.mv("app/scripts.tgz", md5_path)
      md5_path
    end

    def save_scripts_name(scripts_name)
      FileUtils.mkdir_p(File.dirname(@scripts_name_path))
      IO.write(@scripts_name_path, scripts_name)
    end

    # cache this because the file will get removed
    def md5sum
      @md5sum ||= Digest::MD5.file("app/scripts.tgz").to_s[0..7]
    end

    def sh(command)
      puts "=> #{command}"
      system command
    end

  end
end
