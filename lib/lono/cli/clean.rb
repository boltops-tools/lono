require "fileutils"

class Lono::CLI
  class Clean
    include Lono::Utils::Logging
    include Lono::Utils::Sure

    attr_reader :options
    def initialize(options={})
      @options = options
      @mute = options[:mute] # used by CLI::Build at beginning to clear out the output folder
    end

    def run
      folders = %w[output tmp]
      @mute || sure?("Will remove folders: #{folders.join(' ')}")
      folders.each do |folder|
        FileUtils.rm_rf("#{Lono.root}/#{folder}")
      end
      logger.info "Removed folders: #{folders.join(' ')}" unless @mute
    end
  end
end
