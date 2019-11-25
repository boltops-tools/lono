# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
class Lono::Template::Dsl::Builder
  class Section < Base
    def template
      hash, _ = @definition
      hash
    end
  end
end
