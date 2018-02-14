describe Lono::Inspector do
  before(:all) do
    @args = "--noop"
  end

  describe "lono inspect" do
    it "depends" do
      out = execute("exe/lono inspect depends my-stack #{@args}")
      expect(out).to include("Generating dependencies tree")
    end

    it "summary" do
      out = execute("exe/lono inspect summary my-stack #{@args}")
      expect(out).to include("Summary")
    end
  end
end

