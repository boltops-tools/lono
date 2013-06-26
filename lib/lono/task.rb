module Lono
  class Task
    def self.init(options={})
      project_root = options[:project_root] || '.'
      puts "Setting up lono project" unless options[:quiet]
      source_root = File.expand_path("../../starter_project", __FILE__)
      paths = Dir.glob("#{source_root}/**/*").
                select {|p| File.file?(p) }
      paths.each do |src|
        dest = src.gsub(%r{.*starter_project/},'')
        dest = "#{project_root}/#{dest}"

        if File.exist?(dest) and !options[:force]
          puts "already exists: #{dest}" unless options[:quiet]
        else
          puts "creating: #{dest}" unless options[:quiet]
          dirname = File.dirname(dest)
          FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
          FileUtils.cp(src, dest)
        end
      end
      puts "Starter lono project created"
    end
    def self.generate(options)
      new(options).generate
    end

    def initialize(options={})
      @options = options
      @dsl = options.empty? ? DSL.new : DSL.new(options)
    end
    def generate
      @dsl.run(@options)
    end

    def self.bashify(path)
      @bashify = Lono::Bashify.new(:path => path)
      @bashify.run
    end
  end
end