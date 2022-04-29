module Lono::Builder::Dsl::Helpers
  module Ec2
    extend Memoist

    # Returns vpc object
    def vpc(name)
      filters = name == "default" ?
                [name: "isDefault", values: ["true"]] :
                [name: "tag:Name", values: [name]]
      resp = ec2.describe_vpcs(filters: filters)
      resp.vpcs.first
    end
    memoize :vpc

    def default_vpc
      vpc = vpc("default")
      vpc ? vpc.vpc_id : "no default vpc found"
    end

    def default_vpc_cidr
      vpc = vpc("default")
      vpc.cidr_block
    end

    def default_subnets
      return "no default subnets because no default vpc found" if default_vpc == "no default vpc found"
      resp = ec2.describe_subnets(filters: [name: "vpc-id", values: [default_vpc]])
      subnets = resp.subnets
      subnets.map(&:subnet_id)
    end
    memoize :default_subnets

    def key_pairs(regexp=nil)
      resp = ec2.describe_key_pairs
      key_names = resp.key_pairs.map(&:key_name)
      key_names.select! { |k| k =~ regexp } if regexp
      key_names
    end
  end
end
