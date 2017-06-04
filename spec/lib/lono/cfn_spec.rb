require_relative "../../spec_helper"

describe Lono::Cfn do
  before(:all) do
    @args = "--noop --project-root spec/fixtures/my_project"
  end

  describe "lono cfn" do
    it "create stack" do
      out = execute("bin/lono cfn create my-stack #{@args}")
      expect(out).to include("Creating")
    end

    it "update stack" do
      out = execute("bin/lono cfn update my-stack #{@args}")
      expect(out).to include("Updating")
    end

    it "delete stack" do
      out = execute("bin/lono cfn delete my-stack #{@args}")
      expect(out).to include("Deleted")
    end

    it "preview stack" do
      out = execute("bin/lono cfn preview my-stack #{@args}")
      expect(out).to include("CloudFormation preview")
    end

    it "diff stack" do
      out = execute("bin/lono cfn diff my-stack #{@args}")
      expect(out).to include("diff")
    end
  end
end

