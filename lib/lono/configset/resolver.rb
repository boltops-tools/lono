class Lono::Configset
  class Resolver
    extend Memoist

    @@dependencies = [] # save to later regsiter configsets

    @@resolving_message_shown = false
    def resolve(*unresolved)
      unresolved.flatten! # initially only top-level
      puts "Resolving dependencies..." if !@@resolving_message_shown && !unresolved.empty?
      puts "Resolving #{unresolved.map(&:name)}" if ENV['LONO_DEBUG_CONFIGSET']

      @@resolving_message_shown = true

      unresolved.each do |jade|
        jade.check_for_circular_dependency!
        jade.materialize
        jade.dependencies.each do |j|
          @@dependencies << j # store for later registration
          unless j.resolved? or unresolved.include?(j)
            resolve(j)
          end
        end
        jade.resolved! # resolve after depth-first tranversal. So all dependencies have also been resolved at this point.
      end
    end

    def register
      @@dependencies.each do |jade|
        # dependency jades have minimal registry info. For additional info is pulled from stored reference data in
        # jade like jade.resource_from_parent.
        registry = jade.registry
        registry.resource = jade.resource_from_parent
        if jade.type == "blueprint/configset"
          Register::Blueprint.prepend(registry)
        elsif jade.type == "configset"
          Register::Project.prepend(registry)
        end
      end
    end
  end
end
