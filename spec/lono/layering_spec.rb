# Specificity determines lookup
describe Lono::Layering do
  let(:layering) { Lono::Layering.new("params", options, "development", root) }

  def relative(paths)
    paths.map { |p| p.sub(/.*root\d+\//, '') }
  end

  context "all options match: stack, blueprint, template, param" do
    let(:options) { {stack: "ec2", blueprint: "ec2" } }

    context "template level" do
      let(:root) { "spec/fixtures/layering/params/root1" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/ec2.txt",
                              "configs/ec2/params/development/ec2.txt",
                              "configs/ec2/params/development/ec2/ec2.txt"])
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/layering/params/root2" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/ec2.txt",
                              "configs/ec2/params/development/ec2.txt"])
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/layering/params/root3" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt", "configs/ec2/params/ec2.txt"])
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/layering/params/root4" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt"])
      end
    end
  end

  context "direct lookup" do
    let(:options) { {stack: "ec2", blueprint: "ec2", param: "configs/ec2/params/direct/lookup.txt" } }

    context "direct" do
      let(:root) { "spec/fixtures/layering/params/root5" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt", "configs/ec2/params/direct/lookup.txt"])
      end
    end
  end

  context "param override" do
    let(:options) { {stack: "ec2", blueprint: "ec2", param: "my-param" } }

    context "template level" do
      let(:root) { "spec/fixtures/layering/params/root6" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-param.txt",
                              "configs/ec2/params/development/my-param.txt",
                              "configs/ec2/params/development/ec2/my-param.txt"])
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/layering/params/root7" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-param.txt",
                              "configs/ec2/params/development/my-param.txt"])
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/layering/params/root8" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt", "configs/ec2/params/my-param.txt"])
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/layering/params/root9" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt"])
      end
    end
  end

  context "stack override" do
    let(:options) { {stack: "my-stack", blueprint: "ec2" } }

    context "template level" do
      let(:root) { "spec/fixtures/layering/params/root10" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-stack.txt",
                              "configs/ec2/params/development/my-stack.txt",
                              "configs/ec2/params/development/ec2/my-stack.txt"])
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/layering/params/root11" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-stack.txt",
                              "configs/ec2/params/development/my-stack.txt"])
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/layering/params/root12" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt", "configs/ec2/params/my-stack.txt"])
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/layering/params/root13" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt"])
      end
    end
  end

  context "stack and param override: explicitly specified param" do
    let(:options) { {stack: "my-stack", blueprint: "ec2", param: "my-param" } }

    context "template level" do
      let(:root) { "spec/fixtures/layering/params/root14" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-param.txt",
                              "configs/ec2/params/development/my-param.txt",
                              "configs/ec2/params/development/ec2/my-param.txt"])
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/layering/params/root15" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-param.txt",
                              "configs/ec2/params/development/my-param.txt"])
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/layering/params/root16" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt", "configs/ec2/params/my-param.txt"])
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/layering/params/root17" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt"])
      end
    end
  end

  context "all 3 blueprint, template and param are different" do
    let(:options) { {stack: "my-stack", blueprint: "ec2", template: "pet", param: "my-param" } }

    context "template level" do
      let(:root) { "spec/fixtures/layering/params/root18" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-param.txt",
                              "configs/ec2/params/development/my-param.txt",
                              "configs/ec2/params/development/pet/my-param.txt"])
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/layering/params/root19" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt",
                              "configs/ec2/params/my-param.txt",
                              "configs/ec2/params/development/my-param.txt"])
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/layering/params/root20" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt", "configs/ec2/params/my-param.txt"])
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/layering/params/root21" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.txt"])
      end
    end
  end

  context "all options the same from convention" do
    let(:options) { {stack: "ec2", blueprint: "ec2", template: "pet", param: "ec2", param_from_convention: true } }

    context ".sh extension" do
      let(:root) { "spec/fixtures/layering/params/root22" }
      it "locations" do
        result = relative(layering.locations)
        expect(result).to eq(["configs/ec2/params/development.sh"])
      end
    end
  end
end
