module Lono
  class Component
    attr_reader :name
    def initialize(options={})
      @options = options
      @name = options[:name]
    end

    def type
      self.class.name.to_s.split('::').last.underscore # IE: blueprint
    end

    def exist?
      !root.nil?
    end

    def type_dir
      type.pluralize # IE: blueprints
    end

    def root
      paths = Dir.glob("#{Lono.root}/{app,vendor}/#{type_dir}/*")
      paths.find do |path|
        found = path.sub(%r{.*/(app|vendor)/}, '')
        found == "#{type_dir}/#{@name}" # exact match
      end
    end
  end
end
