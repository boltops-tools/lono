class Lono::Cfn::Plan::Changeset
  class Base
    extend Memoist
    include Lono::AwsServices
    include Lono::Utils::Logging
    include Lono::Cfn::Concerns::TemplateOutput

    def initialize(options={})
      @blueprint = options[:blueprint]
      @change_set = options[:change_set]
      @stack = options[:stack]
    end

    def stack
      find_stack(@stack)
    end
    memoize :stack
  end
end
