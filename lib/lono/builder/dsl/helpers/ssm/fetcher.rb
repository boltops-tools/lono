require 'aws-sdk-ssm'

module Lono::Builder::Dsl::Helpers::Ssm
  class Fetcher
    extend Memoist
    include Lono::Utils::Logging

    def get(name)
      fetch_ssm_value(name)
    end

    def fetch_ssm_value(name)
      resp = ssm.get_parameter(name: name, with_decryption: true)
      resp.parameter.value
    rescue Aws::SSM::Errors::ParameterNotFound
      logger.warn 'WARN: SSM-PARAM-NOT-FOUND'
      nil
    end

    def ssm
      Aws::SSM::Client.new
    end
    memoize :ssm
  end
end
