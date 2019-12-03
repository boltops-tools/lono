describe Lono::Param::Generator do
  context "layering" do
    def generate(context)
      setup_params(context)
      param = Lono::Param::Generator.new("example", mute: false)
      json = param.generate
      puts "json:"
      puts json
      data = JSON.load(json)
      data.first["ParameterValue"]
    end

    def setup_params(fixture_type)
      src = "spec/fixtures/params/#{fixture_type}/params"
      dest = "tmp/lono_project/configs/example/params"
      FileUtils.rm_rf(dest) # clear out old fixtures from previous run
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp_r(src, dest)
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
      execute("LONO_PARAM_DEBUG=1 exe/lono generate ec2")
      text = IO.read("#{Lono.root}/output/ec2/params/development.json")
      data = JSON.load(text)
      param = data.select { |i| i["ParameterKey"] == "Ami" }.first
      expect(param["ParameterValue"]).to eq "ami-base-main"
    end
  end
end
