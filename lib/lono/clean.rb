require "fileutils"

class Lono::Clean
  attr_reader :options
  def initialize(options)
    @options = options
    @project_root = options[:project_root] || '.'
  end

  def run
    puts "Cleaning up"
    puts "Removing output/ folder"
    FileUtils.rm_rf("#{@project_root}/output")
  end
end
