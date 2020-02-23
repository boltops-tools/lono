class Lono::Extensions
  class Register < Lono::AbstractBase
    include Lono::Configset::EvaluateFile

    def run
      register_extensions # evaluates extend_with
    end

    # register_extensions and evaluate extend_with methods earlier than load_context so project helpers can override extensions
    def register_extensions
      template_path = "#{Lono.config.templates_path}/#{@template}.rb"
      Lono::Extensions.new(template_path).evaluate # registers extensions
    end
  end
end
