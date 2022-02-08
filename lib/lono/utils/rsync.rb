require 'shellwords'

module Lono::Utils
  module Rsync
    include Lono::Utils::Logging

    def sh(command)
      logger.info "=> #{command}"
      out = `#{command}`
      logger.info out if ENV['LONO_DEBUG_SH']
      success = $?.success?
      raise("ERROR: running command #{command}").color(:red) unless success
      success
    end

    def rsync(src, dest)
      # Using FileUtils.cp_r doesnt work if there are special files like socket files in the src dir.
      # Instead of using this hack https://bugs.ruby-lang.org/issues/10104
      # Using rsync to perform the copy.
      src.chop! if src.ends_with?('/')
      dest.chop! if dest.ends_with?('/')
      check_rsync_installed!
      # Ensures required trailing slashes
      FileUtils.mkdir_p(File.dirname(dest))
      sh "rsync -a --links --no-specials --no-devices #{Shellwords.escape(src)}/ #{Shellwords.escape(dest)}/"
    end

    @@rsync_installed = false
    def check_rsync_installed!
      return if @@rsync_installed # only check once
      if system "type rsync > /dev/null 2>&1"
        @@rsync_installed = true
      else
        raise "ERROR: Rsync is required. Rsync does not seem to be installed.".color(:red)
      end
    end
  end
end
