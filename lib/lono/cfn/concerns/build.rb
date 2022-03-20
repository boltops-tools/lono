module Lono::Cfn::Concerns
  module Build
    extend Memoist

    def build
      Lono::Builder.new(@options)
    end
    memoize :build
  end
end
