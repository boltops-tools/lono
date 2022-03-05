module Lono::Files::Concerns
  module Registration
    def call_line
      @caller.find do |line|
        line.include?(Lono.root.to_s)
      end
    end

    def marker
      "LONO://#{@path}"
    end
  end
end
