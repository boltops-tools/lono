describe Lono::Param::Generator do
  context "layering" do
    def generate(context)
      path = "spec/fixtures/params/#{context}/params/development/network.txt"
      param = Lono::Param::Generator.new("network",
        path: path,
        mute: true,
      )
      json = param.generate
      data = JSON.load(json)
      param_value = data.first["ParameterValue"]
    end

    context "overlay params" do
      it "should combine params" do
        param_value = generate("overlay")
        expect(param_value).to eq "2"
      end
    end

    context "only base param" do
      it "should generate prod param from base param" do
        param_value = generate("baseonly")
        expect(param_value).to eq "foo"
      end
    end

    context "only env param" do
      it "should generate prod param from env param" do
        param_value = generate("envonly")
        expect(param_value).to eq "bar"
      end
    end
  end

  # Load the variables defined in config/variables/* to make available the params/*.txt files
  #
  # Example:
  #
  #   config/variables/base/variables.rb:
  #     @ami = "ami-base-main"
  #
  #   params/base/example.txt:
  #     Ami=<%= @ami %>
  #
  context "shared variables access" do
    it "should have access to shared variables" do
      # quickest to write test by shelling out
      out = execute("exe/lono generate")
      text = IO.read("#{Lono.root}/output/params/example.json")
      data = JSON.load(text)
      param = data.select { |i| i["ParameterKey"] == "Ami" }.first
      expect(param["ParameterValue"]).to eq "ami-base-main"
    end
  end
end
