# Encapsulates syntax methods so they can be included in both the Evaluator and Context scope
class Lono::Builder::Template::Dsl::Evaluator
  module Syntax
    include Fn
    include Lono::Builder::Template::Evaluate
    include Section::Methods
    include ParameterGroup
    include ExtendWith
    include Helpers # built-in helpers
  end
end
