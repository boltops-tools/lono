describe Lono::Param::Generator do
  context "layering" do
    def generate(context)
      setup_params(context)
      param = Lono::Param::Generator.new("example", mute: true)
      json = param.generate
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
      out = execute("LONO_PARAM_DEBUG=1 exe/lono generate ec2")
      text = IO.read("#{Lono.root}/output/ec2/params/development.json")
      data = JSON.load(text)
      param = data.select { |i| i["ParameterKey"] == "Ami" }.first
      expect(param["ParameterValue"]).to eq "ami-base-main"
    end
  end

  context "all 3 blueprint, template and param are the same" do
    let(:generator) { Lono::Param::Generator.new("ec2") }

    it "root1: all 3 form files exist" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root1")
      expect(param_file).to include("configs/ec2/params/development/ec2.txt") # uses simple direct env lookup
    end

    it "root2: long form exists" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root2")
      expect(param_file).to include("configs/ec2/params/development/ec2/ec2.txt")
    end

    it "root3: medium form exists" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root3")
      expect(param_file).to include("configs/ec2/params/development/ec2.txt")
    end

    it "root4: short form exists" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root4")
      expect(param_file).to include("configs/ec2/params/development.txt")
    end
  end

  context "all 3 blueprint, template and param are different" do
    let(:generator) { Lono::Param::Generator.new("ec2", template: "jenkins", param: "large") }
    it "root5: all 3 form files exist" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root5")
      expect(param_file).to include("configs/ec2/params/development/jenkins/large.txt")
    end

    it "root6: long form does not exists" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root6")
      expect(param_file).to be nil
    end
  end

  context "only template and param are the same" do
    let(:generator) { Lono::Param::Generator.new("ec2", template: "jenkins") } # param is the same implicitly
    it "root7: medium form and long form exists" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root7")
      expect(param_file).to include("configs/ec2/params/development/jenkins.txt") # uses simple direct env lookup
    end

    it "root8: medium exists" do
      param_file = generator.lookup_param_file(root: "spec/fixtures/lookup_param_file/root8")
      expect(param_file).to include("configs/ec2/params/development/jenkins.txt")
    end
  end

  context "simple and direct lookup with direct env lookup" do
    let(:generator) { Lono::Param::Generator.new("ec2", template: "doesnt-matter", param: param) } # direct param
    let(:root) { "spec/fixtures/lookup_param_file/root9" }
    context "param with subfolder" do
      let(:param) { "my/test-param" }
      it "root9 direct lookup with a subfolder" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/development/my/test-param.txt")
      end
    end

    context "param without subfolder" do
      let(:param) { "another-test-param" }
      it "root9 direct lookup with a subfolder" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/development/another-test-param.txt")
      end
    end
  end

  context "simple and direct lookup with direct simple lookup" do
    let(:generator) { Lono::Param::Generator.new("ec2", template: "doesnt-matter", param: param) } # direct param
    let(:root) { "spec/fixtures/lookup_param_file/root10" }
    context "param with subfolder" do
      let(:param) { "foo/bar" }
      it "root10 direct lookup with a subfolder" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/foo/bar.txt")
      end
    end

    context "param without subfolder" do
      let(:param) { "baz" }
      it "root10 direct lookup with a subfolder" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/baz.txt")
      end
    end

    context "param with txt added" do
      let(:param) { "baz.txt" }
      it "root10 direct lookup with a subfolder" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/baz.txt")
      end
    end
  end

  context "simple and direct lookup with direct simple lookup with .sh extensions" do
    let(:generator) { Lono::Param::Generator.new("ec2", template: "doesnt-matter", param: param) } # direct param
    let(:root) { "spec/fixtures/lookup_param_file/root11" }
    context "param with sh added" do
      let(:param) { "baz.sh" }
      it "root11 direct lookup with a subfolder" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/baz.sh")
      end
    end
  end

  context "direct full form" do
    let(:generator) { Lono::Param::Generator.new("ec2", template: "doesnt-matter", param: param) } # direct param
    let(:root) { "spec/fixtures/lookup_param_file/root9" }
    context "param with sh added" do
      let(:param) { "configs/ec2/params/development/my/test-param.txt" }
      it "root9 direct_full_form" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/development/my/test-param.txt")
      end
    end
  end

  context "direct direct_relative_form" do
    let(:generator) { Lono::Param::Generator.new("ec2", template: "doesnt-matter", param: param) } # direct param
    let(:root) { "spec/fixtures/lookup_param_file/root9" }
    context "param as direct_full_form" do
      let(:param) { "configs/ec2/params/development/my/test-param.txt" }
      it "root9 direct_relative_form" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/development/my/test-param.txt")
      end
    end

    context "param as direct_absolute_form" do
      let(:param) do
        absolute_root = File.expand_path("../../../fixtures/lookup_param_file/root9", __dir__)
        "#{absolute_root}/configs/ec2/params/development/my/test-param.txt"
      end
      it "root9 direct_absolute_form" do
        param_file = generator.lookup_param_file(root: root)
        expect(param_file).to include("configs/ec2/params/development/my/test-param.txt")
      end
    end
  end
end
