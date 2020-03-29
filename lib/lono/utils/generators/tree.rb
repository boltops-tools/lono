module Lono::Utils::Generators
  module Tree
  private
    def tree_structure(name)
      return if options[:from_new] || options[:import] # only for lono new

      tree_installed = system("type tree > /dev/null 2>&1")
      return unless tree_installed

      structure = `tree .`
      puts <<~EOL
        Here is the structure of your #{name}:

        #{structure}
      EOL
    end
  end
end
