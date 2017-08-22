require_relative "../../../spec_helper"

describe Lono::Param::Generator do
  def generate(project_root)
    param = Lono::Param::Generator.new("network",
      project_root: project_root,
      mute: true
    )
    json = param.generate
    data = JSON.load(json)
    param_value = data.first["ParameterValue"]
  end

  context "overlay params" do
    it "should combine params" do
      param_value = generate("spec/fixtures/params/overlay")
      expect(param_value).to eq "2"
    end
  end

  context "only base param" do
    it "should generate prod param from base param" do
      param_value = generate("spec/fixtures/params/baseonly")
      expect(param_value).to eq "foo"
    end
  end

  context "only env param" do
    it "should generate prod param from env param" do
      param_value = generate("spec/fixtures/params/envonly")
      expect(param_value).to eq "bar"
    end
  end
end
