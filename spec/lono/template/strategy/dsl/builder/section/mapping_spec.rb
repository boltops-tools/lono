describe Lono::Template::Strategy::Dsl::Builder::Section::Mapping do
  let(:mapping) { Lono::Template::Strategy::Dsl::Builder::Section::Mapping.new("ec2", definition) }
  context "medium form" do
    let(:definition) do
      [:AmiMap, {
        "us-east-1": { Ami: "ami-111" },
        "us-east-2": { Ami: "ami-222" },
      }]
    end

    it "produces template" do
      mapping.template
      result = mapping.template
      puts result
      expect(result).to eq(
        {"AmiMap"=>{"us-east-1"=>{"Ami"=>"ami-111"}, "us-east-2"=>{"Ami"=>"ami-222"}}}
      )
    end
  end

  context "long form" do
    let(:definition) do
      [AmiMap: {
        "us-east-1": { Ami: "ami-111" },
        "us-east-2": { Ami: "ami-222" },
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
