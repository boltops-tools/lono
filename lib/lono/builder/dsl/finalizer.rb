class Lono::Builder::Dsl
  class Finalizer
    def initialize(cfn, options={})
      @cfn, @options = cfn, options
    end

    def run
      @cfn = ParameterGroups.new(@cfn, @options[:parameters]).run
      @cfn = Configsets.new(@options.merge(cfn: @cfn)).run
      @cfn
    end
  end
end
