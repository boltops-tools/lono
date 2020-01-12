# Incentive to register. Not meant for security.
class Lono::Registration
  class Check
    extend Memoist

    def initialize(options={})
      @options = options
    end

    def check
      return true if User.new(@options).check
      Temp.new(@options).check
    end
  end
end
