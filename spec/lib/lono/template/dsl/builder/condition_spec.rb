describe Lono::Template::Dsl::Builder::Condition do
  let(:condition) { Lono::Template::Dsl::Builder::Condition.new(definition) }
  context "medium form" do
    # let(:definition) do
    #   [:ami_map, {
    #     "us-east-1": { ami: "ami-111" },
    #     "us-east-2": { ami: "ami-222" },
    #   }]
    # end

    # it "produces template" do
    #   condition.template
    #   result = condition.template
    #   # puts result
    #   expect(result).to eq(
    #     {"AmiMap"=>{"us-east-1"=>{"Ami"=>"ami-111"}, "us-east-2"=>{"Ami"=>"ami-222"}}}
    #   )
    # end
  end

  context "long form" do
    # let(:definition) do
    #   [ami_map: {
    #     "us-east-1": { ami: "ami-111" },
    #     "us-east-2": { ami: "ami-222" },
    #   }]
    # end

    # it "produces template" do
    #   condition.template
    #   result = condition.template
    #   # puts result
    #   expect(result).to eq(
    #     {"AmiMap"=>{"us-east-1"=>{"Ami"=>"ami-111"}, "us-east-2"=>{"Ami"=>"ami-222"}}}
    #   )
    # end
  end
end
