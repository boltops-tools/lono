describe Lono::Param::Generator do
  context "param generator" do
    def generate(context)
      setup_config("params", context)
      setup_config("variables", context)
      param = Lono::Param::Generator.new(
        blueprint: "example",
        stack: "example",
        mute: false)
      data = param.generate
      data.first[:parameter_value]
    end

    def setup_config(config_type, fixture_type)
      src = "spec/fixtures/params/#{fixture_type}/#{config_type}"
      dest = "tmp/lono_project/configs/example/#{config_type}"
      return unless File.exist?(src)
      FileUtils.rm_rf(dest) # clear out old fixtures from previous run
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp_r(src, dest)
    end

    context "layer params" do
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
        param_value = generate("with_vars")
        expect(param_value).to eq "bar"
      end
    end
  end
end
