module Lono::Configset::Strategy::Helpers::Dsl
  module Auth
    def authentication(data=nil, force: false)
      if data.nil?
        authentication_reader
      else
        authentication_setter(data, force)
      end
    end

    # data can be either:
    #
    #     1. logical id - String
    #     2. Full AWS::CloudFormation::Authentication value structure
    #
    def authentication_reader
      # AWS::CloudFormation::Authentication
      case @authentication
      when String
        logical_id = @authentication
        {
          rolebased: {
            type: "S3",
            buckets: [lono_bucket_name],
            roleName: {Ref: logical_id}, # currently ref meth is not available
          }
        }
      when Hash
        @authentication
      end
    end

    def authentication_setter(data, force=false)
      @authentication = data unless @authentication || force
    end
  end
end
