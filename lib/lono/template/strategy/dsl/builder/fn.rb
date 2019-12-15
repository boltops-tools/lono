class Lono::Template::Strategy::Dsl::Builder
  module Fn
    # Also act as documentation on the method signatures
    # Also used in Coder crafting so should always list all the functions here
    # even if they are overriden with specific implementations below
    FUNCTIONS = {
      base64: :simple,
      cidr: :array,
      find_in_map: :array,
      get_att: :array, # special case
      # get_azs: :simple, # special map to GetAZs, and default region=''
      import_value: :simple,
      # join: :array, # special case
      select: :array,
      split: :array,
      # sub: :array, # special case
      transform: :simple,
      # Conditional methods
      # Most of the condition methods need to be accessed via the modulde
      # since they are Ruby keywords. So Fn::if , also builder has an fn method
      # so they can also be called via fn::if
      and: :array,
      equals: :array,
      if: :array, # special case, if is a Ruby keyword
      not: :array,
      or: :array,
      ref: :simple,
    }
    # These are also Ruby keywords
    # keywords: and if not or

    # Defines both normal method and bang method. Example: if and if!
    def self.define_methods(name, &block)
      define_method(name, &block)
      define_method("#{name}!", &block)
    end

    # Note, for if function, do not flatten the args. Its arguments can be Arrays.  Example:
    #
    #   SecurityGroups:
    #     Fn::If:
    #     - ExistingSecurityGroupIsBlank
    #     - - GroupId:
    #           Ref: SecurityGroup
    #     - - GroupId:
    #           Ref: SecurityGroup
    #       - GroupId:
    #           Ref: ExistingSecurityGroup
    FUNCTIONS.each do |name, type|
      if type == :simple
        define_methods(name) do |arg|
          id = fn_id(name)
          { id => arg }
        end
      else # array
        define_methods(name) do |*args|
          id = fn_id(name)
          # Note, do not flatten args for if statement as it can have Array as arguments.
          args = args.flatten unless name == :if
          { id => args }
        end
      end
    end

    def fn_id(name)
      "Fn::#{name.to_s.camelize}"
    end

    # special cases
    def ref(name, options={})
      name = name.to_s.camelize
      conditional = options.delete(:Conditional) || options.delete(:conditional)
      if conditional
        conditional_ref(name, options)
      else
        split_separator = options.delete(:Split) || options.delete(:split)
        if split_separator
          split_separator = ',' if split_separator == true
          split(split_separator, ref(name))
        else
          { "Ref" => name }
        end
      end
    end

    def conditional_ref(name, options)
      fallback = options[:Fallback] || options[:fallback] || ref("AWS::NoValue")
      if!("Has#{name}", ref(name, options), fallback)
    end

    # Examples:
    #   get_attr("logical_id.attribute")
    #   get_attr("logical_id", "attribute")
    #   get_attr(["logical_id", "attribute"])
    def get_att(*item)
      item = item.flatten
      item.last.is_a?(Hash) ? item.pop : {}

      # list is an Array
      list = if item.size == 1
                item.first.split('.')
              else
                item
              end
      # list.map!(&:camelize) unless options[:autoformat] == false # TODO: maybe add as an option.
      # feel this may be to destructive since am going with auto_camelize false for resources now.
      args = [list[0], list[1..-1].join('.')]
      { "Fn::GetAtt" => args }
    end

    def join(delimiter, *list)
      list = list.flatten
      { "Fn::Join" => [delimiter, list] }
    end

    def get_azs(region='')
      { "Fn::GetAZs" => region }
    end

    def sub(str, vals={})
      { "Fn::Sub" => [str, vals] }
    end

    # for fn::if and fn.if to work
    def fn
      Fn
    end
    extend self # for Fn::if and Fn.if

    def self.included(base)
      base.extend(Fn)
    end
  end
end
