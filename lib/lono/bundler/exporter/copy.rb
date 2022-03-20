class Lono::Bundler::Exporter
  class Copy < Base
    def initialize(component)
      @component = component
    end

    def component
      FileUtils.rm_rf(@component.export_path)
      FileUtils.mkdir_p(File.dirname(@component.export_path))
      logger.debug "Copy: cp -r #{src_path} #{@component.export_path}"
      FileUtils.cp_r(src_path, @component.export_path)
      FileUtils.rm_rf("#{@component.export_path}/.git")
    end

    # src path is from the stage area
    def src_path
      path = stage_path(rel_dest_dir)
      path = "#{path}/#{@component.subfolder}" if @component.subfolder
      path
    end
  end
end
