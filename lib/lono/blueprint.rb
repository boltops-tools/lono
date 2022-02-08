module Lono
  class Blueprint
    attr_reader :name
    def initialize(options={})
      @options = options
      @name = options[:blueprint]
    end

    def exist?
      !root.nil?
    end

    def root
      paths = Dir.glob("#{Lono.root}/{app,vendor}/blueprints/*")
      paths.find do |path|
        path.include?("blueprints/#{@name}")
      end
    end

    def output_path
      "#{Lono.root}/output/#{@name}/template.yml"
    end
  end
end
