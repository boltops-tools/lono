class Lono::Builder::Dsl
  class Finalizer
    def initialize(cfn, options={})
      @cfn, @options = cfn, options
    end

    def run
      o = @options.merge(cfn: @cfn)
      @cfn = ParameterGroups.new(o).run
      @cfn = Configsets.new(o).run
      @cfn = Files.new(o).run
      @cfn
    end
  end
end
