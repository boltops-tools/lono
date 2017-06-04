module Lono::Template::Help
  def generate
<<-EOL
Examples:

$ lono template generate

$ lono template g -c # shortcut

Builds the CloudFormation templates files based on lono project and writes them to the output folder on the filesystem.
EOL
  end

  def bashify
<<-EOL
Examples:

$ lono template bashify /path/to/cloudformation-template.json

$ lono template bashify https://s3.amazonaws.com/cloudformation-templates-us-east-1/EC2WebSiteSample.template
EOL
  end

  extend self
end
