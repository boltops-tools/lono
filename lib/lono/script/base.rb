class Lono::Script
  class Base
    SCRIPTS_INFO_PATH = "#{Lono.config.output_path}/data/scripts_info.txt"

    def initialize(options = {})
      @options = options
    end
  end
end
