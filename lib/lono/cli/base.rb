class Lono::CLI
  class Base < Abstract
    def reinitialize(options={})
      super
      @blueprint = Lono::Blueprint.new(options)
      @stack = Lono::Names.new(options).stack
    end
  end
end
