describe Lono::Template::Dsl::Builder::Mapping do
  let(:mapping) { Lono::Template::Dsl::Builder::Mapping.new(definition) }
  context "medium form" do
    let(:definition) do
      [:ami_map, {
        "us-east-1": { ami: "ami-111" },
        "us-east-2": { ami: "ami-222" },
      }]
    end

    it "produces template" do
      mapping.template
      result = mapping.template
      # puts result
      expect(result).to eq(
        {"AmiMap"=>{"us-east-1"=>{"Ami"=>"ami-111"}, "us-east-2"=>{"Ami"=>"ami-222"}}}
      )
    end
  end

  context "long form" do
    let(:definition) do
      [ami_map: {
        "us-east-1": { ami: "ami-111" },
        "us-east-2": { ami: "ami-222" },
      }]
    end

    it "produces template" do
      mapping.template
      result = mapping.template
      # puts result
      expect(result).to eq(
        {"AmiMap"=>{"us-east-1"=>{"Ami"=>"ami-111"}, "us-east-2"=>{"Ami"=>"ami-222"}}}
      )
    end
  end
end
