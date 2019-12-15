describe Lono::Template::Strategy::Dsl::Builder::Section::Parameter do
  let(:parameter) { Lono::Template::Strategy::Dsl::Builder::Section::Parameter.new("ec2", definition) }

  context "short form without default" do
    let(:definition) do
      [ :AmiId ]
    end

    it "produces template" do
      parameter.template
      result = parameter.template
      expect(result).to eq(
        {"AmiId"=>{"Type"=>"String"}}
      )
    end
  end

  context "short form with default" do
    let(:definition) do
      [ :AmiId, "ami-111" ]
    end

    it "produces template" do
      parameter.template
      result = parameter.template
      expect(result).to eq(
        {"AmiId"=>{"Default"=>"ami-111", "Type"=>"String"}}
      )
    end
  end

  context "medium form" do
    let(:definition) do
      [ :Company, { Default: "boltops", Description: "instance type" } ]
    end

    it "produces template" do
      parameter.template
      result = parameter.template
      expect(result).to eq(
        {"Company"=>{"Default"=>"boltops", "Description"=>"instance type", "Type"=>"String"}}
      )
    end
  end

  context "long form" do
    let(:definition) do
      [ Company: { Default: "boltops", Description: "instance type" } ]
    end

    it "produces template" do
      parameter.template
      result = parameter.template
      expect(result).to eq(
        {"Company"=>{"Default"=>"boltops", "Description"=>"instance type", "Type"=>"String"}}
      )
    end
  end

  context "conditional option with inferred default" do
    let(:definition) do
      [ "InstanceType", { Conditional: true } ]
    end

    it "produces template" do
      parameter.template
      result = parameter.template
      expect(result).to eq(
        {"InstanceType"=>{"Default"=>"", "Type"=>"String"}}
      )
    end
  end

  context "conditional option with explicit default as 2nd argument String" do
    let(:definition) do
      [ "InstanceType", "t3.small", { Conditional: true } ]
    end

    it "produces template" do
      parameter.template
      result = parameter.template
      expect(result).to eq(
        {"InstanceType"=>{"Default"=>"t3.small", "Type"=>"String"}}
      )
    end
  end
end
