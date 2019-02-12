describe Lono::Template::Dsl::Builder::Output do
  let(:output) { Lono::Template::Dsl::Builder::Output.new(definition) }

  context "short form without 2nd argument" do
    let(:definition) do
      [ :elb ]
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
      [ :elb, "!Ref Elb" ]
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
      [ :stack_name, { value: "!Ref AWS::StackName" } ]
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
      [ vpc_id: { description: "vpc id", value: "!Ref VpcId" } ]
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
