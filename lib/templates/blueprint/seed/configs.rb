# This is an optional class is used by `lono seed [blueprint]` to create starter configs.
# Example files that get created:
#
#    configs/BLUEPRINT/params/LONO_ENV.txt
#    configs/BLUEPRINT/variables/LONO_ENV.rb
#
# The `Lono::Seed::Configs` class should implement:
#
#   setup: Hook to perform logic at the beginning. A good place to create IAM service roles.
#   variables: Template for generated variables file. Contents of what gets created at
#     configs/[blueprint]/variables/development.rb
#
# Note: There is no need to define a params method. Lono is able to generate a params config starter file by evaluating the template defintion.
#
class Lono::Seed::Configs < Lono::Seed::Base
  # Setup hook
  # def setup
  # end

  # Template for variables.
  # Return String with the content of the config/BLUEPRINT/variables file.
  # def variables
  #   <<~EOL
  #     @variable1=starter_value1
  #     @variable2=starter_value2
  #   EOL
  # end
end
