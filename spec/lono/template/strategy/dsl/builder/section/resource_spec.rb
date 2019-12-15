describe Lono::Template::Strategy::Dsl::Builder::Section::Resource do
  let(:resource) { Lono::Template::Strategy::Dsl::Builder::Section::Resource.new("ec2", definition) }

  context "short form" do
    let(:definition) do
      [ :Vpc, "AWS::EC2::VPC", { CidrBlock: "10.30.0.0/16" } ]
    end

    it "produces template" do
      resource.template
      result = resource.template
      # puts result
      expect(result).to eq(
        {"Vpc"=>{"Type"=>"AWS::EC2::VPC", "Properties"=>{"CidrBlock"=>"10.30.0.0/16"}}}
      )
    end
  end

  context "medium form" do
    let(:definition) do
      [ :Vpc, { Type: "AWS::EC2::VPC", Properties: {CidrBlock: "10.30.0.0/16"} } ]
    end

    it "produces template" do
      resource.template
      result = resource.template
      expect(result).to eq(
        {"Vpc"=>{"Type"=>"AWS::EC2::VPC", "Properties"=>{"CidrBlock"=>"10.30.0.0/16"}}}
      )
    end
  end

  context "long form" do
    let(:definition) do
      [ Vpc: { Type: "AWS::EC2::VPC", Properties: {CidrBlock: "10.30.0.0/16"} } ]
    end

    it "produces template" do
      resource.template
      result = resource.template
      expect(result).to eq(
        {"Vpc"=>{"Type"=>"AWS::EC2::VPC", "Properties"=>{"CidrBlock"=>"10.30.0.0/16"}}}
      )
    end
  end

  context "clean hashes" do
    let(:definition) do
      [ :Vpc, "AWS::EC2::VPC", { CidrBlock: "10.30.0.0/16", FakeProperty: nil } ]
    end

    it "produces template" do
      resource.template
      result = resource.template
      # puts result
      expect(result).to eq(
        {"Vpc"=>{"Type"=>"AWS::EC2::VPC", "Properties"=>{"CidrBlock"=>"10.30.0.0/16"}}}
      )
    end
  end

  context "clean hashes nested in arrays" do
    let(:definition) do
      [ :Vpc, "AWS::EC2::VPC", Origins: [{ CidrBlock: "10.30.0.0/16", FakeProperty: nil }]  ]
    end

    it "produces template" do
      resource.template
      result = resource.template
      # puts result
      expect(result).to eq({
        "Vpc" => {"Properties"=>{"Origins"=>[{"CidrBlock"=>"10.30.0.0/16"}]}, "Type"=>"AWS::EC2::VPC"}
      })
    end
  end
end
