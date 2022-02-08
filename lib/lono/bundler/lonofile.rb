module Lono::Bundler
  class Lonofile
    include Singleton
    extend Memoist
    include LB::Util::Logging

    # dsl meta example:
    # {:global=>{{:org=>"boltopspro"},
    #  :components=>[{:source=>"git@github.com:boltopspro/vpc", :type=>"blueprint", :name=>"vpc"}]
    # }
    def components
      LB.dsl.meta[:components].map do |options|
        Component.new(options)
      end
    end
    memoize :components

    # Checks if any of the components defined in Lonofile has an inferred an org
    # In this case the org must be set
    # When a source is set with an inferred org and org is not set it looks like this:
    #
    #     dsl.meta has {:source=>"terraform-random-pet"}
    #     component.source = "terraform-random-pet"
    #
    # Using info to detect that the org is missing and the Lonofile definition
    # has at least one component line that has an inferred org.
    #
    def missing_org?
      components.detect { |component| component.source.split('/').size == 1 } && LB.config.org.nil?
    end
  end
end
