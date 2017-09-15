class Lono::Importer
  attr_reader :options
  def initialize(options)
    @options = options
    @project_root = options[:project_root] || '.'
  end

  def run
    puts "Importing Raw CloudFormation template and lono-ifying it"
  end
end
