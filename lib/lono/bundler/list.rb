module Lono::Bundler
  class List < CLI::Base
    def run
      file = LB.config.lockfile
      unless File.exist?(file)
        logger.info "No #{file} found".color(:red)
        logger.info "Maybe run: lono bundle"
        return
      end

      logger.info "Components included by #{file}\n\n"
      presenter = CliFormat::Presenter.new(@options.merge(format: "table"))
      presenter.header = ["Name", "Type"]
      lockfile.components.each do |component|
        row = [component.name, component.type]
        presenter.rows << row
      end
      presenter.show
      logger.info "\nUse `lono bundle info` to print more detailed information about a component"
    end

    def lockfile
      Lockfile.instance
    end
  end
end
