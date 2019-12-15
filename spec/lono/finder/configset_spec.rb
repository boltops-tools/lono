describe Lono::Finder::Configset do
  let(:configset) { Lono::Finder::Configset.new(lono_root: lono_root) }

  context "project local" do
    let(:lono_root) { "spec/fixtures/finder/configset/project_only" }
    it "find" do
      root_path = configset.find("ssm").root
      expect(root_path).to include "project_only/app/configsets/ssm"
      root_path = configset.find("non-existing")
      expect(root_path).to be nil
    end
  end

  context "vendor local" do
    let(:lono_root) { "spec/fixtures/finder/configset/vendor_only" }
    it "find" do
      root_path = configset.find("ssm").root
      expect(root_path).to include "vendor_only/vendor/configsets/ssm"
    end
  end

  context "gem remote" do
    let(:lono_root) { "spec/fixtures/finder/configset/gem_only" }
    it "find" do
      allow(configset).to receive(:gem_roots).and_return(["spec/fixtures/finder/configset/gem_only"])

      root_path = configset.find("ssm").root
      expect(root_path).to eq "spec/fixtures/finder/configset/gem_only"
    end
  end

  context "both project and vendor" do
    let(:lono_root) { "spec/fixtures/finder/configset/both" }
    it "find higher precedence project local" do
      root_path = configset.find("ssm").root
      expect(root_path).to include "both/app/configsets/ssm"
    end
  end
end
