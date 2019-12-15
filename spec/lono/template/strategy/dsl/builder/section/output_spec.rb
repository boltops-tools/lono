describe Lono::Template::Strategy::Dsl::Builder::Section::Output do
  let(:output) { Lono::Template::Strategy::Dsl::Builder::Section::Output.new("ec2", definition) }

  context "short form without 2nd argument" do
    let(:definition) do
      [ :Elb ]
    end

    it "produces template" do
      output.template
      result = output.template
      expect(result).to eq(
        {"Elb"=>{"Value"=>{"Ref"=>"Elb"}}}
      )
    end
  end

  context "short form with 2nd argument" do
    let(:definition) do
      [ :Elb, "!Ref Elb" ]
    end

    it "produces template" do
      output.template
      result = output.template
      expect(result).to eq(
        {"Elb"=>{"Value"=>"!Ref Elb"}}
      )
    end
  end

  context "medium form" do
    let(:definition) do
      [ :StackName, { Value: "!Ref AWS::StackName" } ]
    end

    it "produces template" do
      output.template
      result = output.template
      expect(result).to eq(
        {"StackName"=>{"Value"=>"!Ref AWS::StackName"}}
      )
    end
  end

  context "long form" do
    let(:definition) do
      [ VpcId: { Description: "vpc id", Value: "!Ref VpcId" } ]
    end

    it "produces template" do
      output.template
      result = output.template
      expect(result).to eq(
        {"VpcId"=>{"Description"=>"vpc id", "Value"=>"!Ref VpcId"}}
      )
    end
  end
end
