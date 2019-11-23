class Lono::Template::Context
  module Helpers
    extend Memoist

    def ssm(name)
      ssm_fetcher.get(name)
    end

    def ssm_fetcher
      SsmFetcher.new
    end
    memoize :ssm_fetcher
  end
end
