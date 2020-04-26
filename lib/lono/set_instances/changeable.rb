class Lono::SetInstances
  class Changeable < Base
    include Lono::AwsServices
    include Lono::Utils::Sure

    def initialize(options={})
      super # need conventions so config lookup will work
      @regions, @accounts = [], []
    end

    def run
      validate!

      unless stack_set_exists?(@stack)
        puts "ERROR: Cannot update a stack set because #{@stack} does not exists.".color(:red)
        return
      end
      exit_unless_updatable!

      options = {
        stack_set_name: @stack,
        accounts: accounts,
        regions: regions,
      }
      begin
        resp = perform(options)
      rescue Aws::CloudFormation::Errors::ValidationError => e
        # IE: Aws::CloudFormation::Errors::ValidationError: Region eu-north-1 is not supported
        puts "#{e.class}: #{e.message}".color(:red)
        exit 1
      end

      return true if @options[:noop]
      Lono::Sets::Waiter.new(@options).run(resp[:operation_id])
    end

    def validate!
      invalid = (regions.blank? || accounts.blank?) && !@options[:all]
      if invalid
        puts "ERROR: You must provide --accounts and --regions or --all.".color(:red)
        exit 1
      end
    end

    def accounts
      @options[:all] ? stack_instances.map(&:account).uniq : @options[:accounts]
    end

    def regions
      @options[:all] ? stack_instances.map(&:region).uniq : @options[:regions]
    end
  end
end
