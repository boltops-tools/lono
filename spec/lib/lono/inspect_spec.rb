require_relative "../../spec_helper"

describe Lono::Inspector do
  before(:all) do
    @args = "--noop --project-root spec/fixtures/my_project"
  end

  describe "lono inspect" do
    it "depends" do
      out = execute("bin/lono inspect depends my-stack #{@args}")
      expect(out).to include("Generating dependencies tree")
    end

    it "summary" do
      out = execute("bin/lono inspect summary my-stack #{@args}")
      expect(out).to include("Summary")
    end
  end
end

