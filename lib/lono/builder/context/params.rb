class Lono::Builder::Context
  class Params < Lono::Builder::Context
    # These helpers are only defined in the params context.
    # Overriding output resource DSL method
    alias_method :output, :stack_output
  end
end
