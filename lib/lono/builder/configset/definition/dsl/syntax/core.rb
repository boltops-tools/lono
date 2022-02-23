module Lono::Builder::Configset::Definition::Dsl::Syntax
  module Core
    extend Memoist

    #
    # The configset method is different with configset registration vs configset definition
    #
    #   definition:   app/configsets/httpd/configset.rb
    #   registration: app/blueprints/demo/configsets.rb
    #
    def configset(current)
      @tracked << current
      previous, @current = @current, current
      yield
      @current = previous
    end

    %w[package group user file service].each do |meth|
      section = meth.pluralize
      define_method(meth) do |k, props={}|
        init_empty(@current, section)
        current_structure(@current)[section].deep_merge!(k => props)
      end
    end

    # Add extra conveniences to command method
    def command(key, props={})
      init_empty(@current, "commands")

      # order commands automatically
      if key !~ /^\d+_/
        c = @command_counts[@current] += 1 # IE: @command_counts["main"]
        padded_c = "%03d" % c
        key = "#{padded_c}_#{key}"
      end

      # if syntax support
      if props.key?(:if)
        if_clause = props.delete(:if)
        props[:test] = "if #{if_clause} ; then true ; else false ; fi"
        # returns true  - will run command
        # returns false - will not run command
      end

      # unless syntax support
      if props.key?(:unless)
        unless_clause = props.delete(:unless)
        props[:test] = "if #{unless_clause} ; then false ; else true ; fi"
        # returns true  - will run command
        # returns false - will not run command
      end

      current_structure(@current)["commands"].deep_merge!(key => props)
    end

    # Source has a different signature than the other native methods
    def source(*args)
      if args.first.is_a?(Hash)
        item = args.first
      else # 2 args form: first element is k, second is
        k, v, _ = args
        item = {k => v}
      end

      init_empty(@current, "sources")
      current_structure(@current)["sources"].deep_merge!(item)
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
