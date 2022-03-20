# Dont name AwsData. Think prefer AwsInfo vs AwsConcern
module Lono::Concerns
  module AwsInfo
    extend Memoist
    delegate :region, to: :aws_data
    alias_method :aws_region, :region
    alias_method :current_region, :region

    def aws_data
      AwsData.new
    end
    memoize :aws_data
  end
end
