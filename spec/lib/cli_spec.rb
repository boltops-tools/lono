describe Lono::CLI do
  describe "lono" do
    it "generate" do
      out = execute("exe/lono generate")
      expect(out).to include("Generating")
    end
  end
end
