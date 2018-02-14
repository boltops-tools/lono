describe Lono::Cfn do
  before(:all) do
    @env = "LONO_ROOT=#{ENV['LONO_ROOT']}"
    @args = "--noop"
  end

  describe "lono cfn" do
    it "create stack" do
      out = execute("#{@env} bin/lono cfn create my-stack #{@args}")
      expect(out).to include("Creating")
    end

    it "update stack" do
      out = execute("#{@env} bin/lono cfn update my-stack #{@args}")
      expect(out).to include("Updating")
    end

    it "delete stack" do
      out = execute("#{@env} bin/lono cfn delete my-stack #{@args}")
      expect(out).to include("Deleted")
    end

    it "preview stack" do
      out = execute("#{@env} bin/lono cfn preview my-stack #{@args}")
      expect(out).to include("CloudFormation preview")
    end

    it "diff stack" do
      out = execute("#{@env} bin/lono cfn diff my-stack #{@args}")
      expect(out).to include("diff")
    end

    it "download stack" do
      out = execute("#{@env} bin/lono cfn download my-stack #{@args}")
      expect(out).to include("Download")
    end
  end
end

