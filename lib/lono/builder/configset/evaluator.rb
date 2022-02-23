# Dsl or Erb
module Lono::Builder::Configset
  class Evaluator < Lono::CLI::Base
    def evaluate
      Registration.new(@blueprint).evaluate
      combiner = Combiner.new(@options.merge(metas: Registration.metas))
      combiner.combine
    end
  end
end
