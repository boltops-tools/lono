module Lono::S3
  class Bucket
    STACK_NAME = ENV['LONO_STACK_NAME'] || "lono"
    include Lono::AwsServices
    include Lono::Utils::Logging
    extend Lono::AwsServices
    extend Memoist

    class << self
      @@name = nil
      def name
        return @@name if @@name # only memoize once bucket has been created

        check_aws_setup!

        stack = new.find_stack
        return unless stack

        stack_resources = find_stack_resources(STACK_NAME)
        bucket = stack_resources.find { |r| r.logical_resource_id == "Bucket" }
        @@name = bucket.physical_resource_id # actual bucket name
      end

      def check_aws_setup!
        AwsSetup.new.check!
      end
    end

    def initialize(options={})
      @options = options
    end

    def deploy
      if rollback.complete?
        logger.info "Existing '#{STACK_NAME}' stack in ROLLBACK_COMPLETE state. Deleting stack before continuing."
        cfn.delete_stack(stack_name: STACK_NAME)
        status.wait
        status.reset
        stack = nil
      end

      if stack
        update
      else
        create
      end
    end

    def exist?
      !!bucket_name
    end

    def bucket_name
      self.class.name
    end

    def show
      if bucket_name
        logger.info "Lono bucket name: #{bucket_name}"
      else
        logger.info "Lono bucket does not exist yet."
      end
    end

    # Launches a cloudformation to create an s3 bucket
    def create
      logger.info "Creating #{STACK_NAME} stack for s3 bucket to store templates"
      cfn.create_stack(
        stack_name: STACK_NAME,
        template_body: template_body,
        enable_termination_protection: true,
      )
      success = status.wait
      status.reset
      unless success
        logger.info "ERROR: Unable to create lono stack with managed s3 bucket".color(:red)
        exit 1
      end
    end

    def update
      logger.info "Updating #{STACK_NAME} stack with the s3 bucket"
      cfn.update_stack(stack_name: STACK_NAME, template_body: template_body)
    rescue Aws::CloudFormation::Errors::ValidationError => e
      raise unless e.message.include?("No updates are to be performed")
    end

    def delete
      are_you_sure?

      logger.info "Deleting #{STACK_NAME} stack with the s3 bucket"
      disable_termination_protect
      empty_bucket!
      cfn.delete_stack(stack_name: STACK_NAME)
    end

    def disable_termination_protect
      cfn.update_termination_protection(
        stack_name: STACK_NAME,
        enable_termination_protection: false,
      )
    end

    def find_stack
      resp = cfn.describe_stacks(stack_name: STACK_NAME)
      resp.stacks.first
    rescue Aws::CloudFormation::Errors::ValidationError
      nil
    end

    def status
      CfnStatus.new(STACK_NAME)
    end
    memoize :status

  private

    def empty_bucket!
      return unless bucket_name # in case of lono stack ROLLBACK_COMPLETE from failed bucket creation

      resp = s3.list_objects(bucket: bucket_name)
      if resp.contents.size > 0
        # IE: objects = [{key: "objectkey1"}, {key: "objectkey2"}]
        objects = resp.contents.map { |item| {key: item.key} }
        s3.delete_objects(
          bucket: bucket_name,
          delete: {
            objects: objects,
            quiet: false,
          }
        )
        empty_bucket! # keep deleting objects until bucket is empty
      end
    end


    def are_you_sure?
      return true if @options[:yes]

      if bucket_name.nil?
        logger.info "The lono stack and s3 bucket does not exist."
        exit
      end

      logger.info "Are you yes you want the lono bucket #{bucket_name.color(:green)} to be emptied and deleted? (y/N)"
      yes = $stdin.gets.strip
      confirmed = yes =~ /^Y/i
      unless confirmed
        logger.info "Phew that was close."
        exit
      end
    end

    def template_body
      <<~YAML
        Description: Lono managed s3 bucket
        Resources:
          Bucket:
            Type: AWS::S3::Bucket
            Properties:
              BucketEncryption:
                 ServerSideEncryptionConfiguration:
                 - ServerSideEncryptionByDefault:
                    SSEAlgorithm: AES256
              Tags:
                - Key: Name
                  Value: lono
      YAML
    end
  end
end
