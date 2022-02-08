module Lono::Builder::Template::Dsl::Evaluator::Syntax
  module ParameterGroup
    def parameter_group(label)
      @group_label = label
      yield
      @group_label = nil
    end
  end
end
