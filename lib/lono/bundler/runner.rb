module Lono::Bundler
  class Runner < CLI::Base
    def run
      Syncer.new(@options).run
      Exporter.new(@options).run
      # finish_message
    end

    def finish_message
      no_components_found = true
      export_paths.each do |path|
        found = Dir.exist?(path) && !Dir.empty?(path)
        next unless found
        logger.info  "components saved to #{path}"
        no_components_found = false
      end

      logger.info("No components were found.") if no_components_found
    end

    def export_paths
      export_paths = Lonofile.instance.mods.map(&:export_to).compact.uniq
      export_paths << LB.config.export_to
      export_paths
    end
  end
end
