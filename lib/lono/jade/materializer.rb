require "bundler"

class Lono::Jade
  class Materializer
    extend Memoist

    def initialize(jade)
      @jade = jade
    end

    def build
      Materializer::GemsBuilder.new(@jade).build
    end
  end
end
