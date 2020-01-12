require "fileutils"
require "memoist"
require "thor"
require "yaml"

# Subclasses should implement:
#
#   variables - Returns String with content of varibles files.
#   setup - Hook to do extra things like create IAM service roles.
#   finish - Finish hook after config files have been created.
#
# Note there is no params method to hook. The Base class handles params well.
#
class Lono::Seed
  class Base < Lono::AbstractBase
    include Lono::AwsServices
    include ServiceRole

    # What's needed for a Thor::Group or "Sequence"
    # Gives us Thor::Actions commands like create_file
    include Thor::Actions
    include Thor::Base
    # Override Thor::Base initialize
    def initialize(options={})
      reinitialize(options)
    end

    extend Memoist

    def run
      generate_template
      setup
      self.destination_root = Dir.pwd # Thor::Actions require destination_root to be set
      create_params
      create_variables
      finish
    end

    def generate_template
      Lono::Template::Generator.new(@options).run
    end

    def create_params
      return unless params
      create_param_file
    end

    def create_param_file
      @output_template = Lono::Output::Template.new(@blueprint, @template)
      if @output_template.parameters.empty?
        puts "Template has no parameters."
        return
      end

      # Generate by parameter group first
      lines, shown = [], []
      @output_template.parameter_groups.each do |label, parameters|
        lines << "# Parameter Group: #{label}"
        parameters.each do |name|
          lines << parameter_line(name)
          shown << name
        end
        lines << ""
      end if @output_template.parameter_groups

      # Then generate the rest
      @output_template.parameters.each do |name, data|
        lines << parameter_line(name) unless shown.include?(name)
      end

      content = lines.join("\n")
      dest_path = "configs/#{@blueprint}/params/#{Lono.env}.txt" # only support environment level parameters for now
      create_file(dest_path, content) # Thor::Action
    end

    def parameter_line(name)
      data = @output_template.parameters[name]
      example = description_example(data["Description"])
      if data["Default"].nil?
        line = "#{name}=#{example} # (required)"
      else
        default = data["Default"]
        line = "# #{name}=#{default}"
        line = "#{line} # #{example}" if example
      end
      line
    end

    def description_example(description)
      return unless description
      md = description.match(/(Example|IE): (.*)/)
      return unless md
      md[2]
    end

    def params
      true
    end

    def create_variables
      return unless variables
      dest_path = "configs/#{@blueprint}/variables/#{Lono.env}.rb"
      create_file(dest_path, variables) # Thor::Action
    end

    def setup; end
    def finish; end

    # Meant to be overriden by subclass
    # Return String with contents of variables file.
    def variables
      false
    end
  end
end
