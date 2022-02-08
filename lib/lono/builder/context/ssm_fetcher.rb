require 'aws-sdk-ssm'

class Lono::Builder::Context
  class SsmFetcher
    extend Memoist

    def get(name)
      fetch_ssm_value(name)
    end

    def fetch_ssm_value(name)
      resp = ssm.get_parameter(name: name, with_decryption: true)
      resp.parameter.value
    rescue Aws::SSM::Errors::ParameterNotFound
      'SSM-PARAM-NOT-FOUND'
    end

    def ssm
      Aws::SSM::Client.new
    end
    memoize :ssm
  end
end
