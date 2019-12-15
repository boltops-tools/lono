require "text-table"

class Lono::Pro
  class Base
    extend Memoist

    def initialize(options={})
      @options = options
    end

    def api
      Lono::Api::Client.new
    end
    memoize :api
  end
end
