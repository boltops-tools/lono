class Lono::Builder::Dsl::Finalizer
  class Files < Base
    # Replaces metadata under each logical id resource.
    def run
      Build.new(@options).run
      @cfn = Replace.new(@options).run
    end
  end
end
