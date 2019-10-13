require "fileutils"
require "memoist"
require "yaml"

# Subclasses must implement: setup, params, variables
class Lono::Seed
  class Base
    include Lono::AwsServices
    include Helpers
    include Lono::Conventions
    extend Memoist

    def initialize(blueprint, options)
      @blueprint, @options = blueprint, options

      @template, @param = template_param_convention(options)
      @args = options[:args] || {} # hash
      @args.symbolize_keys!

      @written_files = []
      puts "Seeding starter values for #{@blueprint.color(:green)} blueprint configs"
    end

    def run
      setup
      write_configs
      finish
      final_message
    end

    # Should be implemented in subclass
    def setup; end
    def params; end
    def variables; end

    # Optionally implemented in subclasses
    def params_form
      :short # can be short, medium, or long
    end

    def finish; end

  protected
    def params_path
      case params_form.to_sym
      when :short
        "configs/#{@blueprint}/params/#{Lono.env}.txt"
      when :medium
        "configs/#{@blueprint}/params/#{Lono.env}/#{@param}.txt"
      else
        "configs/#{@blueprint}/params/#{Lono.env}/#{@template}/#{@param}.txt"
      end
    end

    def variables_path
      "configs/#{@blueprint}/variables/#{Lono.env}.rb"
    end

    def base_params_path
      params_path.sub("params/#{Lono.env}", "params/base")
    end

    def base_variables_path
      variables_path.sub("variables/#{Lono.env}", "variables/base")
    end

    def write_configs
      @params, @variables = params, variables # so it only gets called once
      write_file(params_path, @params) if @params
      write_file(variables_path, @variables) if @variables
    end

  private

    def write_file(path, content)
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, content)
      @written_files << path
    end

    def final_message
      config_list = @written_files.map { |i| "  * #{i}" }.join("\n")

      puts <<~EOL
        The #{@blueprint} blueprint configs are in:

        #{config_list}

        The starter values are specific to your AWS account. They meant to
        be starter values. Please take a look, you may want to adjust the values.
      EOL
    end
  end
end
