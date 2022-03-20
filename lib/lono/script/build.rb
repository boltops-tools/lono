require "digest"
require "fileutils"

module Lono::Script
  class Build < Base
    # Only avaialble after script has been built.
    def self.scripts_name
      new.scripts_name
    end

    def run
      reset
      if Dir["#{@blueprint.root}/scripts/*"].empty?
        return
      else
        logger.info "Detected scripts"
      end

      logger.info "Tarballing scripts folder to scripts.tgz"
      tarball_path = create_tarball
      save_scripts_info(tarball_path)
      logger.info "Tarball created at #{tarball_path}"
    end

    # Only avaialble after script has been built.
    def scripts_name
      IO.read(SCRIPTS_INFO_PATH).strip
    end

    def reset
      FileUtils.rm_f(SCRIPTS_INFO_PATH)
    end

    def create_tarball
      # https://apple.stackexchange.com/questions/14980/why-are-dot-underscore-files-created-and-how-can-i-avoid-them
      # using system to avoid displaying command
      system "cd #{@blueprint.root} && dot_clean ." if system("type dot_clean > /dev/null 2>&1")

      # https://serverfault.com/questions/110208/different-md5sums-for-same-tar-contents
      # Using tar czf directly results in a new m5sum each time because the gzip
      # timestamp is included.  So using:  tar -c ... | gzip -n
      sh "cd #{@blueprint.root} && tar -c scripts | gzip -n > scripts.tgz" # temporary scripts.tgz file

      rename_with_md5!
    end

    # Apppend a md5 to file after it's been created and moves it to
    # output/scripts/scripts-[MD5].tgz
    def rename_with_md5!
      md5_path = "output/#{@blueprint.name}/scripts/scripts-#{md5sum}.tgz"
      FileUtils.mkdir_p(File.dirname(md5_path))
      FileUtils.mv("#{@blueprint.root}/scripts.tgz", md5_path)
      md5_path
    end

    def save_scripts_info(scripts_name)
      FileUtils.mkdir_p(File.dirname(SCRIPTS_INFO_PATH))
      IO.write(SCRIPTS_INFO_PATH, scripts_name)
    end

    # cache this because the file will get removed
    def md5sum
      @md5sum ||= Digest::MD5.file("#{@blueprint.root}/scripts.tgz").to_s[0..7]
    end

  end
end
