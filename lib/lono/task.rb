module Lono
  class Task
    def self.init(options={})
      project_root = options[:project_root] || '.'
      puts "Settin up lono project" unless options[:quiet]
      %w[Guardfile config/lono.rb templates/app.json.erb].each do |name|
        source = File.expand_path("../../files/#{name}", __FILE__)
        dirname = File.dirname(name)
        FileUtils.mkdir(dirname) unless File.exist?(dirname)
        dest = "#{project_root}/#{name}"

        if File.exist?(dest)
          puts "already exists: #{dest}" unless options[:quiet]
        else
          puts "creating: #{dest}" unless options[:quiet]
          FileUtils.cp(source, dest)
        end
      end
    end
    def self.generate(options)
      new(options).generate
    end

    def initialize(options={})
      @options = options
      if options.empty?
        @dsl = DSL.new
      else
        @dsl = DSL.new(options)
      end
    end
    def generate
      @dsl.run(@options)
    end
  end
end