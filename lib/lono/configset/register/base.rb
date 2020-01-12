# Subclasses must implement:
#
#    evaluate
#
module Lono::Configset::Register
  class Base < Lono::AbstractBase
    class_attribute :configsets
    class_attribute :validations
    class_attribute :source

    include Dsl
    include Lono::Configset::EvaluateFile

    def register
      evaluate
      jadify
    end

    def jadify
      self.class.configsets.each do |registry|
        Lono::Jade.new(registry.name, jade_type, registry)
      end
    end

    def jade_type
      finder_class.to_s.sub('Lono::Finder::','').underscore
    end

    # Used in Base#validate!
    def finder_class
      case self
      when Lono::Configset::Register::Blueprint
        Lono::Finder::Blueprint::Configset
      when Lono::Configset::Register::Project
        Lono::Finder::Configset
      end
    end

    # Store to be able to provide the validation errors altogether later.
    def store_for_validation(registry)
      # save caller line to use later for pointing to exactly line
      caller_line = caller.grep(/evaluate_file/).first
      registry.caller_line = caller_line
      # huge performance improvement by only validating the first configset registration of duplicate gems
      names = self.class.validations.map {|r| r.name }
      self.class.validations << registry unless names.include?(registry.name)
    end

    # Validate the configset before building templates. So user finds out about errors early.
    def validate!
      errors = []
      self.class.validations.each do |registry|
        config = finder_class.find(registry.name) # finder_class implemented in subclass
        errors << [:finder_missing, registry] unless config

        if registry.depends_on.nil? && registry.resource.nil?
          errors << [:resource_missing, registry]
        end
      end

      return if errors.empty? # all good
      show_errors_and_exit!(errors)
    end

    def show_errors_and_exit!(errors)
      errors.each do |error_type, registry|
        name, caller_line = registry.name, registry.caller_line
        case error_type
        when :finder_missing
          puts "ERROR: Configset with name #{name} not found. Please double check Gemfile and configs/#{@blueprint}/configsets files.".color(:red)
          pretty_trace(caller_line)
        when :resource_missing
          puts "ERROR: Configset with name #{name} does not specify resource. The resource key is required.".color(:red)
          pretty_trace(caller_line)
          raise
        end
      end
      exit 1
    end

    def pretty_trace(caller_line)
      md = caller_line.match(/(.*\.rb):(\d+):/)
      path, error_line_number = md[1], md[2].to_i

      context = 5 # lines of context
      top, bottom = [error_line_number-context-1, 0].max, error_line_number+context-1

      puts "Showing file: #{path}"
      lines = IO.read(path).split("\n")
      spacing = lines.size.to_s.size
      lines[top..bottom].each_with_index do |line_content, index|
        current_line_number = top+index+1
        if current_line_number == error_line_number
          printf("%#{spacing}d %s\n".color(:red), current_line_number, line_content)
        else
          printf("%#{spacing}d %s\n", current_line_number, line_content)
        end
      end
    end

  public
    class << self
      def clear!
        self.configsets = []
        self.validations = []
      end

      def prepend(registry)
        self.configsets.unshift(registry) unless has?(registry)
      end

      def append(registry)
        self.configsets << registry unless has?(registry)
      end

      def has?(registry)
        configsets.detect { |r| r.name == registry.name && r.args == registry.args }
      end
    end
  end
end
