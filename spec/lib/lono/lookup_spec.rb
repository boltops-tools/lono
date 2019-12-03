# Specificity determines lookup
describe Lono::Location do
  let(:location) { Lono::Location.new(options, root) }

  context "all options match: stack, blueprint, template, param" do
    let(:options) { {stack: "ec2", blueprint: "ec2", template: "ec2", param: "ec2" } }

    context "template level" do
      let(:root) { "spec/fixtures/lookup/params/root1" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/ec2/ec2.txt") # template level - most specificity
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/lookup/params/root2" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/ec2.txt") # env level
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/lookup/params/root3" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/ec2.txt") # params level
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/lookup/params/root4" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development.txt") # generic level
      end
    end
  end

  context "direct lookup" do
    let(:options) { {stack: "ec2", blueprint: "ec2", template: "ec2", param: "configs/ec2/params/direct/lookup.txt" } }

    context "direct" do
      let(:root) { "spec/fixtures/lookup/params/root5" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/direct/lookup.txt") # direct lookup
      end
    end
  end

  context "param override" do
    let(:options) { {stack: "ec2", blueprint: "ec2", template: "ec2", param: "my-param" } }

    context "template level" do
      let(:root) { "spec/fixtures/lookup/params/root6" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/ec2/my-param.txt") # template level - most specificity
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/lookup/params/root7" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/my-param.txt") # env level
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/lookup/params/root8" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/my-param.txt") # params level
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/lookup/params/root9" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development.txt") # generic level
      end
    end
  end

  context "stack override" do
    let(:options) { {stack: "my-stack", blueprint: "ec2", template: "ec2", param: "ec2", param_from_convention: true } }

    context "template level" do
      let(:root) { "spec/fixtures/lookup/params/root10" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/ec2/my-stack.txt") # template level - most specificity
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/lookup/params/root11" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/my-stack.txt") # env level
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/lookup/params/root12" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/my-stack.txt") # params level
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/lookup/params/root13" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development.txt") # generic level
      end
    end
  end

  context "stack and param override: explicitly specified param" do
    let(:options) { {stack: "my-stack", blueprint: "ec2", template: "ec2", param: "my-param" } }

    context "template level" do
      let(:root) { "spec/fixtures/lookup/params/root14" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/ec2/my-param.txt") # template level - most specificity
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/lookup/params/root15" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/my-param.txt") # env level
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/lookup/params/root16" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/my-param.txt") # params level
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/lookup/params/root17" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development.txt") # generic level
      end
    end
  end

  context "all 3 blueprint, template and param are different" do
    let(:options) { {stack: "my-stack", blueprint: "ec2", template: "pet", param: "my-param" } }

    context "template level" do
      let(:root) { "spec/fixtures/lookup/params/root18" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/pet/my-param.txt") # template level - most specificity
      end
    end

    context "env level" do
      let(:root) { "spec/fixtures/lookup/params/root19" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development/my-param.txt") # env level
      end
    end

    context "params level" do
      let(:root) { "spec/fixtures/lookup/params/root20" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/my-param.txt") # params level
      end
    end

    context "generic env level" do
      let(:root) { "spec/fixtures/lookup/params/root21" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development.txt") # generic level
      end
    end
  end

  context "all options the same from convention" do
    let(:options) { {stack: "ec2", blueprint: "ec2", template: "pet", param: "ec2", param_from_convention: true } }

    context ".sh extension" do
      let(:root) { "spec/fixtures/lookup/params/root22" }
      it "lookup" do
        result = location.lookup
        expect(result).to include("configs/ec2/params/development.sh") # generic level
      end
    end
  end
end
