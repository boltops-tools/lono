class Lono::Builder::Configset::Definition
  class Erb < Base
    def evaluate
      load_context
      cloudformation_init = build
      wrap_with_metadata(cloudformation_init)
    end

    def build
      content = RenderMePretty.result(@configset.path, context: self)
      if File.extname(@configset.path) == ".yml"
        load_yaml(content)
      else
        JSON.load(content)
      end
    end

    def load_yaml(content)
      # init structure
      # Write to file so can use Yamler::Validator
      path = "/tmp/lono/configset.yml"
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, content)
      Lono::Yamler::Validator.new(path).validate!
      Lono::Yamler::Loader.new(content).load
    end

    def authentication
      # noop
    end
  end
end
