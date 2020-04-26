class Lono::SetInstances
  class Create < Changeable
    def perform(options)
      cfn.create_stack_instances(options)
    end
  end
end
