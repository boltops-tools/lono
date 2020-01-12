class Lono::Jade
  module Circular
    def check_for_circular_dependency!
      circular = circular_dependency?
      return unless circular

      puts "ERROR: configset circular dependency detected".color(:red)
      puts "circular dependency: #{parent_names.join(" => ")}"
      exit 1
    end

    def circular_dependency?
      parent_names.uniq.size != parent_names.size
    end

    def parent_names
      names = [self.name] # include initial jade name to detect circular dependency earlier
      parent = registry.parent
      while parent
        names << parent.name
        parent = parent.registry.parent
      end
      names
    end
  end
end
