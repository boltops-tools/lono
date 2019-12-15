class Lono::Configset::Meta
  module Dsl
    def depends_on(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      registry = Lono::Configset::Registry.new(args, options)
      registry.depends_on = args.first
      registry.parent = @jade
      already_has = @jade.depends_ons.detect { |d| d.name == registry.name && d.args == registry.args }
      @jade.depends_ons << registry unless already_has
    end
  end
end
