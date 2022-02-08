class Lono::Bundler::CLI
  class Base
    include LB::Util::Logging
    include LB::Util::Sure

    def initialize(options={})
      @options = options
    end
  end
end
