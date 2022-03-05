class Lono::CLI
  class Base < Abstract
    include Lono::Concerns::Names

    def initialize(options={})
      super
      @blueprint = Lono::Blueprint.new(options.merge(name: options[:blueprint]))
      @stack = names.stack
    end
  end
end
