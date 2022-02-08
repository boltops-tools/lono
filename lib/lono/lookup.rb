module Lono
  class Lookup
    include Lono::Utils::Logging
    include Lono::Utils::Pretty

    def list(type)
      Dir.glob("#{Lono.root}/{app,vendor}/#{type}/*").each do |path|
        logger.info pretty_path(path)
      end
    end
  end
end
