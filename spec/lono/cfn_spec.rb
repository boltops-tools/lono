describe Lono::Cfn do
  before(:all) do
    @args = "--noop"
  end

  describe "lono cfn" do
    it "cancel stack" do
      out = execute("#{@env} exe/lono cfn cancel example #{@args}")
      expect(out).to include("Cancel")
    end

    it "deploy stack" do
      out = execute("#{@env} exe/lono cfn deploy example #{@args}")
      expect(out).to include("Deploy")
    end

    it "delete stack" do
      out = execute("#{@env} exe/lono cfn delete example #{@args}")
      expect(out).to include("Delet")
    end

    it "preview stack" do
      out = execute("#{@env} exe/lono cfn preview example #{@args}")
      expect(out).to include("CloudFormation preview")
    end

    it "download stack" do
      out = execute("#{@env} exe/lono cfn download example #{@args}")
      expect(out).to include("Download")
    end
  end
end

