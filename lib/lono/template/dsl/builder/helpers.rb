# Built-in helpers for the DSL form
class Lono::Template::Dsl::Builder
  module Helpers
    extend Memoist
    include CoreHelper
    include ParamHelper
  end
end
