class Lono::Param::Help
  class << self
    def generate
<<-EOL
Example:

To generate a CloudFormation json parameter files in the params folder to the output/params folder.

$ lono-params generate

If you have params/my-stack.txt. It will generate a CloudFormation json file in output/params/my-stack.json.
EOL
    end
  end
end
