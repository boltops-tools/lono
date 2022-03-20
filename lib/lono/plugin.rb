module Lono
  class Plugin
    include Meta
    delegate_to_meta :name, :root

    def initialize(options={})
      @options = options
    end
  end
end
