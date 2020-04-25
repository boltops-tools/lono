class Lono::SetInstances
  class Update < Changeable
    def perform(options)
      cfn.update_stack_instances(options)
    rescue Aws::CloudFormation::Errors::StackInstanceNotFoundException => e
      puts "#{e.class}: #{e.message}".color(:red)
      puts <<~EOL
        One of the provided stack instance was not found. Unable to update the stack instances unless all stack instances
        already exist. It may be helpful to check the StackSet console Instances Tab. You can also use the
        `lono set_instances deploy` command instead.
      EOL
      exit 1
    end
  end
end
