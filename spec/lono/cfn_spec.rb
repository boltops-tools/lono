describe Lono::Cfn do
  before(:all) do
    @args = "--noop"
  end

  describe "lono cfn" do
    it "create stack" do
      out = execute("#{@env} exe/lono cfn create example #{@args}")
      expect(out).to include("Create")
    end

    it "update stack" do
      out = execute("#{@env} exe/lono cfn update example #{@args}")
      expect(out).to include("Update")
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

