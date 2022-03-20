module Lono::Builder::Dsl::Helpers
  module Ec2
    extend Memoist

    def default_vpc
      resp = ec2.describe_vpcs(filters: [name: "isDefault", values: ["true"]])
      vpc = resp.vpcs.first
      vpc ? vpc.vpc_id : "no default vpc found"
    end
    memoize :default_vpc

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
