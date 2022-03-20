class Lono::Plugin
  class Tester
    class << self
      def register(name, options={})
        Lono::Plugin.register(
          name: name,
          type: "test_framework",
          root: options[:root],
        )
      end
    end
  end
end
