module Lono::Utils
  module CallLine
    include Pretty

    def lono_call_line
      caller.find { |l| l.include?(Lono.root.to_s) }
    end
  end
end
