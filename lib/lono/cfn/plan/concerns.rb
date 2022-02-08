class Lono::Cfn::Plan
  module Concerns
    extend Memoist

    def summary
      Summary.new
    end
    memoize :summary
  end
end
