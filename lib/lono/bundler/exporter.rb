module Lono::Bundler
  class Exporter
    include LB::Component::Concerns::PathConcern
    include LB::Util::Logging

    def initialize(options={})
      @options = options
    end

    def run
      purge_all
      components.each do |component|
        logger.info "Exporting #{component.export_path}"
        purge(component)
        export(component)
      end
    end

    def components
      components = lockfile.components
      if LB.update_mode? && !@options[:components].empty?
        components.select! { |component| @options[:components].include?(component.name) }
      end
      components
    end

    def export(component)
      fetcher = Component::Fetcher.new(component).instance
      fetcher.run
      fetcher.switch_version(component.sha)
      copy = Copy.new(component)
      copy.component
    end

  private
    def purge_all
      return if LB.update_mode?
      return unless LB.config.export_purge
      FileUtils.rm_rf(LB.config.export_to)
    end

    def purge(component)
      FileUtils.rm_rf(component.export_path)
    end

    def lockfile
      Lockfile.instance
    end
  end
end
