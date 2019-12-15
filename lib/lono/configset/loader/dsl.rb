class Lono::Configset::Loader
  module Dsl
    def indent(text, indentation_amount)
      text.split("\n").map do |line|
        " " * indentation_amount + line
      end.join("\n")
    end
  end
end
