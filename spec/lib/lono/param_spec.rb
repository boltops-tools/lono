require_relative "../../spec_helper"

describe Lono::Param do
  before(:all) do
    @args = "--project-root spec/fixtures/my_project"
  end

  describe "lono param" do
    it "generate" do
      out = execute("bin/lono param generate #{@args}")
      expect(out).to include("Generating")
    end
  end
end

