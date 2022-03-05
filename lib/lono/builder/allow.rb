module Lono::Builder
  class Allow < Lono::CLI::Base
    def check!
      Env.new(@options).check!
      Region.new(@options).check!
    end
  end
end
