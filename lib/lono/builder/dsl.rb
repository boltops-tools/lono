module Lono::Builder
  class Dsl < Lono::CLI::Base
    attr_reader :results
    def run
      logger.info "Building template" unless @options[:quiet]
      build_template
    end

    def build_template
      evaluator = Evaluator.new(@options)
      evaluator.build
    end
  end
end
