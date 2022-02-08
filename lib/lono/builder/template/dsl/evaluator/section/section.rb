# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
module Lono::Builder::Template::Dsl::Evaluator::Section
  class Section < Base
    def template
      hash, _ = @definition
      camelize(hash)
    end
  end
end
