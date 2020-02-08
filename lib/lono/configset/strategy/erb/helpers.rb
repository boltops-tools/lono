class Lono::Configset::Strategy::Erb
  module Helpers
    def indent(text, indentation_amount)
      text.split("\n").map do |line|
        " " * indentation_amount + line
      end.join("\n")
    end
  end
end
