describe Lono::Cfn::Preview::Param do
  let(:preview) do
    Lono::Cfn::Preview::Param.new("ec2")
  end

  let(:optional_parameters) do
    {"Foo"=>
      {"Default"=>123,
       "Description"=>"desc test",
       "Type"=>"String"},
     "Bar"=>{"Default"=>"db.t3.small", "Type"=>"String"}}
  end
  let(:generate_all) do
    [{:parameter_key=>"Cat", :parameter_value=>"456"},
     {:parameter_key=>"Dog", :parameter_value=>"whatever"}]
  end
  let(:stack_parameters) do
    [
      Aws::CloudFormation::Types::Parameter.new(parameter_key: "StorageEncrypted", parameter_value: "true"),
      Aws::CloudFormation::Types::Parameter.new(parameter_key: "EngineMode", parameter_value: ""),
    ]
  end

  context "normalize" do
    it "generated_params" do
      allow(preview).to receive(:generate_all).and_return(generate_all)
      expect(preview.generated_params).to eq(
        {"Dog"=>"whatever", "Cat"=>"456"}
      )
    end

    it "optional_params" do
      allow(preview).to receive(:optional_parameters).and_return(optional_parameters)
      expect(preview.optional_params).to eq(
        {"Foo"=>"123", "Bar"=>"db.t3.small"}
      )
    end

    it "existing_params" do
      allow(preview).to receive(:stack_parameters).and_return(stack_parameters)
      expect(preview.existing_params).to eq(
        {"EngineMode"=>"", "StorageEncrypted"=>"true"}
      )
    end

    it "new_params" do
      allow(preview).to receive(:generate_all).and_return(generate_all)
      allow(preview).to receive(:optional_parameters).and_return(optional_parameters)
      allow(preview).to receive(:stack_parameters).and_return(stack_parameters)
      expect(preview.new_params.keys.sort).to eq(%w[Bar Cat Dog Foo].sort)
    end
  end
end
