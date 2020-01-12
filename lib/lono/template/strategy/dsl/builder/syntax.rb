# Encapsulates syntax methods so they can be included in both the Builder and Context scope
class Lono::Template::Strategy::Dsl::Builder
  module Syntax
    include Fn
    include Lono::Template::Evaluate
    include Section::Methods
    include Section::Extensions
    include Helpers # built-in helpers
  end
end
