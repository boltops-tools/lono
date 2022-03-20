# Encapsulates syntax methods so they can be included in both the Evaluator and Context scope
class Lono::Builder::Dsl
  module Syntax
    include Fn
    include Core
    include ParameterGroup
    include Helpers
  end
end
