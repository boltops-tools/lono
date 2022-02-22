module Lono::Builder::Context
  class Params < Generic
    # Overriding output resource DSL method
    alias_method :output, :stack_output
  end
end
