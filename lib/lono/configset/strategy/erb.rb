require "json"

module Lono::Configset::Strategy
  class Erb < Base
    include Helpers::Erb

    def find_evaluation_path
      paths = %w[configset.yml configset.json].map { |p| "#{@root}/lib/#{p}" }
      paths.find { |p| File.exist?(p) }
    end

    def load
      content = RenderMePretty.result(@evaluation_path, context: self)
      # init structure
      if File.extname(@evaluation_path) == ".yml"
        load_yaml(content)
      else
        JSON.load(content)
      end
    end

    def authentication
      # noop
    end

    def load_yaml(content)
      # Write to file so can use Yamler::Validator
      path = "/tmp/lono/configset.yml"
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, content)
      Lono::Yamler::Validator.new(path).validate!
      Lono::Yamler::Loader.new(content).load
    end
  end
end
