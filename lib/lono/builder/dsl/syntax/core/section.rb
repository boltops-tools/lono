# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
module Lono::Builder::Dsl::Syntax::Core
  class Section < Base
    def template
      hash, _ = @definition
      camelize(hash)
    end
  end
end
