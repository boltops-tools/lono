class Lono::Configure
  module Helpers
    extend Memoist

    def get_input(key, default:'')
      value = get_seed(key, default: default, load_default: @options[:defaults])
      return value if value

      default_text = default.blank? ? '' : "(default: #{default})"
      print "Please provide value for #{key}#{default_text}: "
      value = $stdin.gets.strip
      value.blank? ? load_default(default) : value
    end

    # Defaults to loading the default
    def get_seed(key, default:, load_default: true)
      seed_value = from_seed(key)
      if seed_value
        puts "For #{key}, using seed value #{seed_value}"
        return seed_value
      end

      return load_default(default) if load_default
    end

    def load_default(default)
      if default.is_a?(Symbol)
        send(default) # IE: default_subnet
      else
        default # return the default as is
      end
    end

    def default_subnet
      subnet_ids.first
    end

    def default_vpc_id
      vpc = find_vpc
      vpc.vpc_id if vpc # default vpc might have been deleted
    end

    def default_key_name
      key_name
    end

    def from_seed(key)
      seed[key.to_s]
    end

    def seed
      if @options[:seed] == :convention
        convention_path = "seeds/#{@blueprint}/#{Lono.env}.yml"
        seed_file = convention_path
      else
        seed_file = @options[:seed]
      end

      unless File.exist?(seed_file)
        puts "WARN: unable to find seed file #{seed_file}".color(:yellow) if @options[:seed] != :convention
        return {}
      end
      puts "Using seed file: #{seed_file}"
      YAML.load_file(seed_file)
    end
    memoize :seed

    def key_name
      resp = ec2.describe_key_pairs
      key = resp.key_pairs.first

      if key
        key.key_name
      else
        "Please create a keypair and configure it here"
      end
    end

    def aws_account
      sts.get_caller_identity.account
    end

    def subnet_ids(vpc_id: nil, regexp: nil)
      vpc = find_vpc(vpc_id)
      unless vpc
        # sometimes even default VPC has been deleted
        abort "ERROR: Cannot find subnets because cannot find vpc #{@vpc_id} Please double check that is the right vpc".color(:red)
      end

      resp = ec2.describe_subnets(filters: [{name: 'vpc-id', values: [vpc.vpc_id]}])
      subnets = resp.subnets # first subnet

      # Assume that the subnets have a Name tag with PrivateSubnet1, PrivateSubnet2, etc
      # This is part of the BoltOps blueprint stack.
      selected_subnets = select_subnets(subnets, regexp)

      # if cannot find selected subnets, then keep all the subnets
      subnets = selected_subnets unless selected_subnets.empty?
      subnets.map(&:subnet_id)
    end

    def select_subnets(subnets, regexp=nil)
      return subnets unless regexp

      subnets.select do |subnet|
        tags = subnet.tags
        name_tag = tags.find { |t| t.key == "Name" }
        name_tag && name_tag.value =~ regexp
      end
    end

    # If not vpc_id is provided, it tries to find the default vpc.
    # If the default vpc doesnt exist, nilt is returned.
    def find_vpc(vpc_id=nil)
      if vpc_id
        resp = ec2.describe_vpcs(vpc_ids: [vpc_id])
      else
        resp = ec2.describe_vpcs(filters: [{name: "isDefault", values: ["true"]}])
      end

      vpcs = resp.vpcs
      vpcs.first
    rescue Aws::EC2::Errors::InvalidVpcIDNotFound
      nil
    end
    memoize :find_vpc
  end
end