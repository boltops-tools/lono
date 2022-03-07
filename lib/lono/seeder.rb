require "fileutils"
require "memoist"
require "thor"
require "yaml"

module Lono
  class Seeder < Lono::CLI::Base
    extend Memoist
    include Lono::AwsServices
    include Lono::Cfn::Concerns::TemplateOutput

    def run
      build_template
      build_params
      build_vars
    end

    def build_template
      Lono::Builder::Template.new(@options).run
    end

    def build_params
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
      dest_path = "#{dest_folder}/params/#{Lono.env}.env" # only support environment level parameters for now
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

    def build_vars
      src = "#{@blueprint.root}/seed/vars"
      dest = "#{dest_folder}/vars"
      directory(src, dest) if File.exist?(src)
    end

    # config structure:
    #
    #   config/blueprints/demo
    #
    # general structure:
    #
    #   app/blueprints/demo/config
    #   vendor/blueprints/demo/config
    #
    def dest_folder
      where = @options[:where] || Lono.config.seed.where
      if where == "config"
        "#{Lono.root}/config/blueprints/#{@blueprint.name}"
      else # app or vendor
        "#{Lono.root}/#{where}/blueprints/#{@blueprint.name}/config"
      end
    end

  private
    def create_file(dest_path, content) # Thor::Action)
      sequence.create_file(dest_path, content)
    end

    def directory(src, dest)
      sequence.send(:set_template_paths, src)
      sequence.destination_root = Lono.root
      sequence.directory(".", dest, context: binding) # Thor::Action
    end

    def sequence
      sequence = Lono::CLI::New::Sequence.new(@options)
    end
    memoize :sequence
  end
end
