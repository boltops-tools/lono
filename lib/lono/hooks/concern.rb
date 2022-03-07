module Lono::Hooks
  module Concern
    def run_hooks(name, &block)
      hooks = Builder.new(@blueprint, name)
      hooks.build # build hooks
      hooks.run_hooks(&block)
    end
  end
end
