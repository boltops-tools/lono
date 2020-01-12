module Lono
  # This class is not use by lono internally. It is really only meant to be
  # exposed to the lono userdata command so users can debug their generated
  # app/user_data scripts. It is useful for debugging.
  #
  # Normally, the Lono::Erb#run method generates the CloudFormation templates
  # and embeds user-data script into the template.
  class UserData < AbstractBase
    def initialize(options={})
      super
      @name = options[:name]
      @path = "#{Lono.root}/app/user_data/#{@name}.sh"
    end

    def generate
      puts "Generating user_data for '#{@name}' at #{@path}"
      if File.exist?(@path)
        puts RenderMePretty.result(@path, context: context)
      else
        puts "ERROR: #{@path} does not exist".color(:red)
        exit 1
      end
    end

    # Context for ERB rendering.
    # This is where we control what references get passed to the ERB rendering.
    def context
      @context ||= Lono::Template::Context.new(@options)
    end
  end
end
