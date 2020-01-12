require "fileutils"

class Lono::Clean
  attr_reader :options
  def initialize(options={})
    @options = options
  end

  def run
    puts "Clean: removing output/ and tmp/ folder"
    FileUtils.rm_rf("#{Lono.config.output_path}")
    FileUtils.rm_rf("#{Lono.root}/tmp")
  end
end
