module Lono::Template::Strategy
  # url or path
  class Source < Base
    def run
      Lono::Cfn::Download.new(@options).run
    end
  end
end
