class Lono::New
  attr_reader :options
  def initialize(options)
    @options = options
    @project_root = options[:project_root] || '.'
    @format = options[:format] || 'json'
  end

  def run
    puts "Setting up lono project" unless options[:quiet]
    source_root = File.expand_path("../../starter_projects/#{@format}_project", __FILE__)
    paths = Dir.glob("#{source_root}/**/*").
              select {|p| File.file?(p) }
    paths.each do |src|
      # starter_projects/yaml_project/ ->
      regexp = Regexp.new(".*starter_projects/#{@format}_project/")
      dest = src.gsub(regexp,'')
      dest = "#{@project_root}/#{dest}"

      if File.exist?(dest) and !options[:force]
        puts "already exists: #{dest}" unless options[:quiet]
      else
        puts "creating: #{dest}" unless options[:quiet]
        dirname = File.dirname(dest)
        FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
        FileUtils.cp(src, dest)
      end
    end
    puts "Starter lono project created" unless options[:quiet]
  end
end
