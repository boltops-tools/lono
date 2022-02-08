module Lono::Builder::Template::Dsl::Evaluator::Syntax
  module ExtendWith
    def extend_with(extension)
      # Do nothing during the main DSL evaluation. The extend_with logical actual runs during during the
      # pre_evalation stage before project helpers are loaded. This allows project helper to override extend helpers.
      # Define the method here it does not error though.
    end
  end
end
