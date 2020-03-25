require "thor"

module Lono::AppFile
  class Build < Base
    include Lono::Utils::Item::Zip

    def initialize_variables
      @output_files_path = "#{Lono.config.output_path}/#{@blueprint}/files"
    end

    def run
      return unless detect_files?
      puts "Building app/files for blueprint #{@blueprint}"
      build_all
    end

    def build_all
      clean_output
      validate_files!
      copy_to_output
      build_layers
      compress_output
    end

    def validate_files!
      items = Registry.items + Registry.layers
      missing = items.select do |item|
        !File.exist?(item.src_path)
      end
      missing_paths = missing.map { |item| item.src_path }.uniq
      unless missing_paths.empty?
        puts "ERROR: These app/files are missing were used by the s3_key method but are missing".color(:red)
        missing_paths.each do |path|
          puts "    #{path}"
        end
        puts "Please double check that they exist."
        exit 1
      end
    end

    def build_layers
      layer_items = Registry.layers
      layer_items.each do |item|
        LambdaLayer.new(@blueprint, item).build
      end
    end

    def compress_output
      Registry.items.each do |item|
        # type can be lambda_layer or file
        if item.type == "lambda_layer" || item.exist?
          zip(item)
        else
          puts "WARN: #{item.src_path} does not exist. Double check that the path is correct in the s3_key call.".color(:yellow)
        end
      end
    end

    def copy_to_output
      override_source_paths("#{Lono.blueprint_root}/app/files")
      self.destination_root = @output_files_path
      directory(".", verbose: false, context: context.get_binding) # Thor::Action
    end

    def context
      Lono::Template::Context.new(@options)
    end
    memoize :context

    def clean_output
      FileUtils.rm_rf(@output_files_path)
    end

    def detect_files?
      app_files = Dir["#{Lono.blueprint_root}/app/files/*"]
      if app_files.empty?
        false
      else
        puts "Detected app/files for blueprint #{@blueprint}"
        true
      end
    end
  end
end
