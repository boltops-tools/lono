class Lono::Inspector::Help
  class << self
    def summary
<<-EOL
Example:

$ lono inspect summary my-stack

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
