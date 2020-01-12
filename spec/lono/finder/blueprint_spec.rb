describe Lono::Finder::Blueprint do
  let(:blueprint) { Lono::Finder::Blueprint.new(lono_root: lono_root) }

  context "project local" do
    let(:lono_root) { "spec/fixtures/finder/blueprint/project_only" }
    it "find" do
      root_path = blueprint.find("ec2").root
      expect(root_path).to include "project_only/app/blueprints/ec2"
      root_path = blueprint.find("non-existing")
      expect(root_path).to be nil
    end
  end

  context "vendor local" do
    let(:lono_root) { "spec/fixtures/finder/blueprint/vendor_only" }
    it "find" do
      root_path = blueprint.find("ec2").root
      expect(root_path).to include "vendor_only/vendor/blueprints/ec2"
    end
  end

  context "gem remote" do
    let(:lono_root) { "spec/fixtures/finder/blueprint/gem_only" }
    it "find" do
      allow(blueprint).to receive(:gem_roots).and_return(["spec/fixtures/finder/blueprint/gem_only"])

      root_path = blueprint.find("ec2").root
      expect(root_path).to eq "spec/fixtures/finder/blueprint/gem_only"
    end
  end

  context "both project and vendor" do
    let(:lono_root) { "spec/fixtures/finder/blueprint/both" }
    it "find higher precedence project local" do
      root_path = blueprint.find("ec2").root
      expect(root_path).to include "both/app/blueprints/ec2"
    end
  end
end
