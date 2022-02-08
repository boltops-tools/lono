class Lono::Seeder
  module ServiceRole
    def create_service_linked_role(aws_service_name)
      iam.create_service_linked_role(
        aws_service_name: aws_service_name
      )
    rescue Aws::IAM::Errors::InvalidInput # already exist
      raise if ENV['LONO_DEBUG_SEED']
    end
  end
end
