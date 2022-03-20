class Lono::CLI
  class Abstract
    extend Memoist
    include Lono::Utils::Logging
    include Lono::Utils::Pretty

    def initialize(options={})
      @options = options
    end
  end
end
