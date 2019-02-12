class Lono::Cfn
  module Suffix
    # Appends a short suffix at the end of a stack name.
    # Lono internally strips this same suffix for the template name.
    # Makes it convenient for the development flow.
    #
    #   lono cfn current --suffix 1
    #   lono cfn create demo => demo-1
    #   lono cfn update demo-1
    #
    # Instead of typing:
    #
    #   lono cfn create demo-1 --template demo
    #   lono cfn update demo-1 --template demo
    #
    # The suffix can be specified at the CLI but can also be saved as a
    # preference.
    #
    # A random suffix can be specified with random. Example:
    #
    #   lono cfn current --suffix random
    #   lono cfn create demo => demo-[RANDOM], example: demo-abc
    #   lono cfn update demo-abc
    #
    # It is not a default setting because it might confuse new lono users.
    @@append_suffix = nil
    def append_suffix(stack_name)
      return @@append_suffix if @@append_suffix
      return stack_name unless allow_suffix?

      suffix ||= stack_name_suffix == 'random' ? random_suffix : stack_name_suffix
      @@append_suffix = [stack_name, suffix].compact.join('-')
    end

    def remove_suffix(stack_name)
      return stack_name unless allow_suffix?
      return stack_name unless stack_name_suffix

      if stack_name_suffix == 'random'
        stack_name.sub(/-(\w{3})$/,'') # strip the random suffix at the end
      elsif stack_name_suffix
        pattern = Regexp.new("-#{stack_name_suffix}$",'')
        stack_name.sub(pattern, '') # strip suffix
      else
        stack_name
      end
    end

    def allow_suffix?
      %w[Lono::Cfn::Create Lono::Cfn::Deploy].include?(self.class.to_s)
    end

    # only generate random suffix for Create class
    def random_suffix
      return nil unless allow_suffix?
      (0...3).map { (65 + rand(26)).chr }.join.downcase # Ex: jhx
    end

    def stack_name_suffix
      if @options[:suffix] && !@options[:suffix].nil?
        return @options[:suffix] # CLI option takes highest precedence
      end

      Lono.suffix # core.rb accounts for LONO_SUFFIX env variable, current, and settings
    end
  end
end