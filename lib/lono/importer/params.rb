class Lono::Importer
  class Params
    include Thor::Actions
    include Thor::Base
    extend Memoist

    attr_reader :options
    def initialize(template_path, params_path)
      @template_path, @params_path = template_path, params_path
      @params_path = normalize_path(@params_path)
      self.destination_root = Dir.pwd # Thor::Actions require destination_root to be set
      @options = {} # For Thor::Actions to work
    end

    # Creates starter params/base/[stack-name].txt file
    def create
      result = []
      required_parameters.each do |name, attributes|
        result << "#{name}=#{attributes["Default"]}"
      end
      optional_parameters.each do |name, attributes|
        key = "#{name}=".ljust(20, ' ')
        result << "##{key} # optional"
      end
      content = result.join("\n") + "\n"


      folder = File.dirname(@params_path)
      FileUtils.mkdir_p(folder) unless File.exist?(folder)
      create_file(@params_path, content) # Thor::Action
    end

    def required_parameters
      parameters.reject { |logical_id, p| p["Default"] }
    end

    def optional_parameters
      parameters.select { |logical_id, p| p["Default"] }
    end

    def parameters
      template_data["Parameters"] || []
    end

    def template_data
      YAML.load(IO.read(@template_path))
    end
    memoize :template_data

  private
    # Add Lono.root if not already there, helps cli_spec.rb to pass
    def normalize_path(path)
      path.include?(Lono.root.to_s) ? path : "#{Lono.root}/#{path}"
    end
  end
end