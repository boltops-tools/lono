describe Lono::Template::Strategy::Dsl::Builder::Section::Condition do
  let(:condition) { Lono::Template::Strategy::Dsl::Builder::Section::Condition.new("ec2", definition) }
  context "medium form" do
    let(:definition) do
      [:AmiMap, {
        "us-east-1": { Ami: "ami-111" },
        "us-east-2": { Ami: "ami-222" },
      }]
    end

    it "produces template" do
      condition.template
      result = condition.template
      # puts result
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
      condition.template
      result = condition.template
      # puts result
      expect(result).to eq(
        {"AmiMap"=>{"us-east-1"=>{"Ami"=>"ami-111"}, "us-east-2"=>{"Ami"=>"ami-222"}}}
      )
    end
  end
end
