module Lono::Cfn
  class Base < Lono::CLI::Base
    extend Memoist

    include Lono::AwsServices
    include Lono::Utils::Sure
    include Lono::Utils::Logging
    include Lono::Utils::Pretty
    include Lono::Utils::Quit

    include Concerns

    delegate :template_path, to: :build
  end
end
