class Lono::Bundler::Component::Props
  module Extension
    def props(*names)
      names.each { |n| prop(n) }
    end

    def prop(name)
      name = name.to_sym
      define_method(name) do
        @props[name]
      end

      define_method("#{name}=") do |v|
        @props[name] = v
      end
    end
  end
end
