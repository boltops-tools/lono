require "fileutils"
require "memoist"
require "thor"
require "yaml"

module Lono
  class Seeder < Lono::CLI::Base
    include Lono::AwsServices
    include Lono::Cfn::Concerns::TemplateOutput
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
      build_template
      self.destination_root = Dir.pwd # Thor::Actions require destination_root to be set
      create_params
      create_variables
    end

    def build_template
      Lono::Builder::Template.new(@options).run
    end

    def create_params
      create_param_file
    end

    def create_param_file
      if template_output.parameters.empty?
        logger.info "Template has no parameters."
        return
      end

      # Generate by parameter group first
      lines, shown = [], []
      template_output.parameter_groups.each do |label, parameters|
        lines << "# Parameter Group: #{label}"
        parameters.each do |name|
          parameter_line = parameter_line(name)
          lines << parameter_line unless lines.include?(parameter_line)
          shown << name
        end
        lines << ""
      end if template_output.parameter_groups

      # Then generate the rest
      template_output.parameters.each do |name, data|
        lines << parameter_line(name) unless shown.include?(name)
      end

      content = lines.join("\n")
      dest_path = "config/blueprints/#{@blueprint.name}/params/#{Lono.env}.txt" # only support environment level parameters for now
      create_file(dest_path, content) # Thor::Action
    end

    def parameter_line(name)
      data = template_output.parameters[name]
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

    def self.source_root
      Lono.root
    end

    def create_variables
      src = "#{@blueprint.root}/seed/vars"
      dest = "#{Lono.root}/config/blueprints/#{@blueprint.name}/vars"
      directory(src, dest) if File.exist?(src)
    end

  private
    def env
      Lono.env # allows for seed/vars/%env%.rb.tt
    end
  end
end
