module Lono
  # This class is not use by lono internally. It is really only meant to be
  # exposed to the lono user_data command so users can debug their generated
  # user_data scripts. It is useful for debugging.
  #
  # Normally, the Lono::Erb#run method generates the CloudFormation template
  # and embeds user-data script into the template.
  class UserData < Lono::CLI::Base
    include Lono::Builder::Dsl::Syntax

    def initialize(options={})
      super
      @name = options[:name]
      @path = "#{Lono.root}/app/user_data/#{@name}.sh"
    end

    def generate
      pretty_path = pretty_path(@path)
      logger.info "Building user_data for '#{@name}' at #{pretty_path}"
      if File.exist?(@path)
        logger.info RenderMePretty.result(@path, context: self)
      else
        logger.info "ERROR: #{pretty_path} does not exist".color(:red)
        exit 1
      end
    end
  end
end
