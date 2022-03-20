module Lono::Yamler
  class Validator
    include Lono::Utils::Logging
    include Lono::Utils::Pretty

    def initialize(path)
      @path = path
    end

    def validate!
      validate_yaml(@path)
    end

    def validate_yaml(path)
      text = IO.read(path)
      begin
        YAML.load(text)
      rescue Psych::SyntaxError => e
        handle_yaml_syntax_error(e, path)
      end
    end

    def handle_yaml_syntax_error(e, path)
      logger.error "ERROR: Invalid YAML. #{e.message}".color(:red)
      logger.error "Template for debugging: #{pretty_path(path)}"

      # Grab line info.  Example error:
      #   ERROR: (<unknown>): could not find expected ':' while scanning a simple key at line 2 column 1
      md = e.message.match(/at line (\d+) column (\d+)/)
      line = md[1].to_i

      DslEvaluator.print_code(path, line)
      exit 1
    end
  end
end
