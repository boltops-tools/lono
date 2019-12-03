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
end
