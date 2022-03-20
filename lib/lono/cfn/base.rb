module Lono::Cfn
  class Base < Lono::CLI::Base
    extend Memoist
    include Lono::AwsServices
    include Lono::Hooks::Concern
    include Lono::Utils::Logging
    include Lono::Utils::Pretty
    include Lono::Utils::Quit
    include Lono::Utils::Sure

    include Concerns

    delegate :template_path, to: :build
  end
end
