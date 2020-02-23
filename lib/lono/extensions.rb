module Lono
  class Extensions
    include Dsl
    include Lono::Template::Evaluate

    def initialize(template_path)
      @template_path = template_path
    end

    def evaluate
      evaluate_template_path(@template_path) # handle extend_with
    end

    # The extend_with methods are used in file as the normal DSL evaluation.
    # We use method_missing so we dont have to redefine all the normal methods of the DSL.
    def method_missing(name, *args, &block); end
  end
end
