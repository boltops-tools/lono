module Lono::Bundler
  class Config
    extend Memoist
    include Singleton

    def config
      config = ActiveSupport::OrderedOptions.new
      config.base_clone_url = "https://github.com/"
      config.export_to = ENV['LB_EXPORT_TO'] || "vendor"
      config.export_purge = ENV['LB_EXPORT_PRUNE'] == '0' ? false : true
      config.lonofile = ENV['LB_LONOFILE'] || "Lonofile"
      config.lockfile = "#{config.lonofile}.lock"
      config.logger = Lono.config.logger
      config
    end
    memoize :config
  end
end
