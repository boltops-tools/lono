module Lono::Concerns
  module Names
    extend Memoist
    def names
      Lono::Names.new(@options)
    end
    memoize :names
  end
end
