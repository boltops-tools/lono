# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
class Lono::Template::Dsl::Builder
  class Section < Base
    def template
      hash, _ = @definition
      camelize(hash)
    end
  end
end
