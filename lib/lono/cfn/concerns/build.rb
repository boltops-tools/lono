module Lono::Cfn::Concerns
  module Build
    extend Memoist

    def build
      Lono::CLI::Build.new(@options)
    end
    memoize :build
  end
end
