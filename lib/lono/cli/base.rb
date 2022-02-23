class Lono::CLI
  class Base < Abstract
    def reinitialize(options={})
      super
      @blueprint = Lono::Blueprint.new(options.merge(name: options[:blueprint]))
      @stack = Lono::Names.new(options).stack
    end
  end
end
