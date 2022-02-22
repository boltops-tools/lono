module Lono::Builder::Dsl::Helpers
  module Ssm
    extend Memoist

    def ssm(name)
      ssm_fetcher.get(name)
    end

    def ssm_fetcher
      Fetcher.new
    end
    memoize :ssm_fetcher
  end
end
