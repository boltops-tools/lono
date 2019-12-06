# Encapsulates syntax methods so they can be included in both the Builder and Context scope
class Lono::Template::Dsl::Builder
  module Syntax
    include Fn
    include Lono::Template::Evaluate
    include SectionMethods
    include Helpers # built-in helpers
  end
end
