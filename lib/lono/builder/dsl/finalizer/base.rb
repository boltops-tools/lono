class Lono::Builder::Dsl::Finalizer
  class Base < Lono::CLI::Base
    def initialize(options={})
      super
      @cfn = options[:cfn]
    end
  end
end
