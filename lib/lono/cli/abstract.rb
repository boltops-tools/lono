class Lono::CLI
  class Abstract
    extend Memoist
    include Lono::Utils::Contexts
    include Lono::Utils::Logging
    include Lono::Utils::Pretty

    def initialize(options={})
      reinitialize(options)
    end

    # Hack so that we can use include Thor::Base
    def reinitialize(options)
      @options = options
    end
  end
end
