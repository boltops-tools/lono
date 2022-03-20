class Lono::Cfn::Deploy
  class Tags < Base
    # Maps to CloudFormation format.  Example:
    #
    #   {"a"=>"1", "b"=>"2"}
    # To
    #   [{key: "a", value: "1"}, {key: "b", value: "2"}]
    #
    def values
      tags = Lono.config.up.tags
      return if tags.nil? # nil = keep current tags. [] = remove all tags

      tags.map do |k,v|
        { key: k.to_s, value: v }
      end
    end
  end
end
