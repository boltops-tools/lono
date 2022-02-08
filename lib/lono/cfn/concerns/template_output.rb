module Lono::Cfn::Concerns
  module TemplateOutput
    extend Memoist

    def template_output
      Lono::Builder::Template::Output.new(@blueprint)
    end
    memoize :template_output
  end
end
