class Lono::Builder
  class Template < Lono::CLI::Base
    extend Memoist

    def run
      check_blueprint_exist!
      data = dsl.run # The generator strategy classes write templates to disk
      write_output(data)
    end

  private
    def check_blueprint_exist!
      return if @blueprint.exist?
      logger.error "ERROR: Blueprint #{@blueprint.name} not found.".color(:red)
      logger.error <<~EOL
        Searched:

            app/blueprints
            vendor/blueprints

        Are you sure it exists? To check, you can run:

            lono list

      EOL
      exit 1
    end

    def write_output(data)
      path = @blueprint.output_path
      ensure_parent_dir(path)
      text = YAML.dump(data)
      IO.write(path, text)

      Lono::Yamler::Validator.new(path).validate!

      unless @options[:quiet]
        pretty_path = path.sub("#{Lono.root}/",'')
        logger.info "    #{pretty_path}"
      end
    end

    def ensure_parent_dir(path)
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end

    def dsl
      Dsl.new(@options)
    end
    memoize :dsl
  end
end
