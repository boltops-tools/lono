class Lono::Bundler::Component::Fetcher
  class Local < Base
    def run
      stage_path = stage_path(rel_dest_dir)
      source = @component.source
      src = source.sub(/^~/, ENV['HOME']) # allow ~/ notation
      FileUtils.rm_rf(stage_path)
      FileUtils.mkdir_p(File.dirname(stage_path))
      logger.debug "Local: cp -r #{src} #{stage_path}"
      # copy from stage area to vendor/blueprints/NAME
      # IE: cp -r /tmp/lono/bundler/stage/local/local1 vendor/blueprints/local1
      FileUtils.cp_r(src, stage_path)
    end
  end
end
