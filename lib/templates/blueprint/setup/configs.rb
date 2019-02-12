# This class is used by `lono configure [blueprint]` to create starter config files.
# Example files that get created:
#
# Variables:
#
#    configs/[blueprint]/variables/[Lono.env].rb
#
# Params:
#
#    configs/[blueprint]/params/[Lono.env].txt - short form
#    configs/[blueprint]/params/[Lono.env]/[param].txt - medium form
#    configs/[blueprint]/params/[Lono.env]/[template]/[param].txt - large form
#
# Subclasses of `Lono::Configure::Base` should implement:
#
#   setup: Hook to perform logic at the beginning. Examples:
#     * Setting instance variables used in the params or variables template methods.
#     * Creating pre-defined IAM roles required by the template.
#   params: Template for generated params file. Contents of what gets created at
#     configs/[blueprint]/params/development/[param].txt
#   variables: Template for generated variables file. Contents of what gets created at
#     configs/[blueprint]/variables/development.rb
#
class Configs < Lono::Configure::Base
  # Setup hook
  def setup
    # Custom setup logic
    # set_instance_variables
  end

  # Template for params
  def params
    <<~EOL
      Parameter1=StarterValue1
      Parameter2=StarterValue1
      # Optional
      # Parameter3=OptionalStarterValue1
    EOL
  end

  # Template for variables
  # def variables
  #   <<~EOL
  #     @variable1=starter_value1
  #     @variable2=starter_value2
  #   EOL
  # end

private
  # Example:
  # def set_instance_variables
  #   @instance_type = "t3.micro"
  # end
end
