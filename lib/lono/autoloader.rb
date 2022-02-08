require "lono/bundler"
Lono::Bundler.setup
require "zeitwerk"

module Lono
  class Autoloader
    class Inflector < Zeitwerk::Inflector
      def camelize(basename, _abspath)
        map = { cli: "CLI", version: "VERSION" }
        map[basename.to_sym] || super
      end
    end

    class << self
      def setup
        loader = Zeitwerk::Loader.new
        loader.inflector = Inflector.new
        loader.push_dir(File.dirname(__dir__)) # lib
        loader.log! if ENV["LONO_AUTOLOAD_LOG"]
        loader.setup
      end
    end
  end
end
