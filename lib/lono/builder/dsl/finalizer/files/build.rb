class Lono::Builder::Dsl::Finalizer::Files
  class Build < Base
    def initialize(options={})
      super
      @output_path = "#{Lono.root}/.output/files"
    end

    def run
      return if Lono::Files.empty?
      logger.debug "Building files"
      clean
      validate!
      build_files
      # build_layers
    end

    def build_files
      Lono::Files.files.each do |file| # using singular file, but is like a "file_list"
        file.build
        file.compress
        # Note: Uploading files happen right before create_stack or execute_change_set
        # after user confirms action, instead of part of the build process
      end
    end

    # TODO: LambdaLayer support
    # def build_layers
    #   layer_items = Registry.layers
    #   layer_items.each do |item|
    #     LambdaLayer.new(@blueprint, item).build
    #   end
    # end
    #

    def clean
      FileUtils.rm_rf(@output_path)
    end

    def validate!
      missing = Lono::Files.files.select do |file|
        !File.exist?(file.full_path)
      end
      return if missing.empty?

      logger.info "ERROR: These files are missing".color(:red)
      logger.info <<~EOL
        The file helper is calling them.
        They need to exist to be uploaded to s3.
      EOL
      missing.each do |file|
        logger.info "    #{pretty_path(file.full_path)}"
        logger.info "    Called at #{file.call_line}"
      end
      logger.info "Please double check that they exist."
      exit 1
    end
  end
end
