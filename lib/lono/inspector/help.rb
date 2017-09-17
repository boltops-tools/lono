class Lono::Inspector::Help
  class << self
    def params
<<-EOL
Example:

$ lono inspect params my-stack

EOL
    end

    def depends
<<-EOL
Example:

$ lono inspect depends my-stack

EOL
    end
  end
end
