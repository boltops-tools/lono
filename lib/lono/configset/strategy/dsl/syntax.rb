# Core syntax
class Lono::Configset::Strategy::Dsl
  module Syntax
    extend Memoist

    %w[package group user resource file command service].each do |meth|
      section = meth.pluralize
      define_method(meth) do |k, props|
        init_empty(@current, section)
        current_structure(@current)[section].deep_merge!(k => props)
      end
    end

    def configset(current)
      @tracked << current
      previous, @current = @current, current
      yield
      @current = previous
    end

  private
    def current_structure(configset)
      @structure[configset] ||= {}
    end
    memoize :current_structure

    def init_empty(configset, section)
      current = current_structure(configset)
      current[section] ||= {}
    end
  end
end
