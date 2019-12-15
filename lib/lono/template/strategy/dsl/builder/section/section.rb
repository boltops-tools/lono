# Implements:
#
#   template - uses @definition to build a CloudFormation template section
#
module Lono::Template::Strategy::Dsl::Builder::Section
  class Section < Base
    def template
      hash, _ = @definition
      camelize(hash)
    end
  end
end
