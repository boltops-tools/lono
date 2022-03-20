module Lono::Files::Concerns
  module Registration
    def call_line
      @caller.find do |line|
        line.include?(Lono.root.to_s)
      end
    end

    # IE:
    #   LONO:://files/function-normal
    #   LONO:://files/function-layer
    def marker
      "LONO://#{@path}-#{@type}"
    end
  end
end
