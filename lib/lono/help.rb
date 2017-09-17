module Lono::Help
  def new_long_desc
<<-EOL
Examples:

$ lono new project

$ lono new lono
EOL
  end

  def import
<<-EOL
Examples:

$ lono import /path/to/file

$ lono import http://url.com/path/to/template.json

$ lono import http://url.com/path/to/template.yml

Imports a raw CloudFormation template and lono-fies it.
EOL
  end

  def generate
<<-EOL
Examples:

$ lono generate

$ lono g -c # shortcut

Builds both CloudFormation template and parameter files based on lono project and writes them to the output folder on the filesystem.
EOL
  end

  def template
<<-EOL
Examples:

$ lono template generate --help

$ lono template bashify --help
EOL

  end

  def cfn
<<-EOL
Examples:

$ lono cfn create my-stack

$ lono cfn preview my-stack

$ lono cfn update my-stack

$ lono cfn delete my-stack
EOL
  end

  def param
<<-EOL
Examples:

$ lono param generate
EOL
  end

  def inspector
<<-EOL
Examples:

$ lono inspect params my-stack

$ lono inspect depends my-stack
EOL
  end

  extend self
end
