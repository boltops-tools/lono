module Lono
  module Help
    def new_long_desc
<<-EOL
Examples:

$ lono new project

$ lono new lono
EOL
    end

    def generate
<<-EOL
Examples:

$ lono generate

$ lono g -c # shortcut

Builds the cloud formation templates files based on lono project and writes them to the output folder on the filesystem.
EOL
    end

    def bashify
<<-EOL
Examples:

$ lono bashify /path/to/cloudformation-template.json

$ lono bashify https://s3.amazonaws.com/cloudformation-templates-us-east-1/EC2WebSiteSample.template
EOL
    end

    extend self
  end
end