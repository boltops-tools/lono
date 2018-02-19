require "fileutils"

class Lono::Clean
  attr_reader :options
  def initialize(options)
    @options = options
  end

  def run
    puts "Cleaning up"
    puts "Removing output/ folder"
    FileUtils.rm_rf("#{Lono.config.output_path}")
  end
end
