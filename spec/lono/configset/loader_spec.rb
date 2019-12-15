describe Lono::Configset::Loader do
  let(:loader) do
    Lono::Configset::Loader.new(registry)
  end
  let(:registry) do
    Lono::Configset::Registry.new(["ssm"], resource: "Instance")
  end

  context("example") do
    it "loads metadata" do
      data = loader.load
      expect(data).to be_a(Hash)
      init_key = data.key?("AWS::CloudFormation::Init")
      expect(init_key).to be true
    end
  end
end
