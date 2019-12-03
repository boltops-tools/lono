describe Lono::Param do
  before(:all) do
    @args = ""
  end

  describe "lono param" do
    it "generate" do
      out = execute("exe/lono param generate #{@args}")
      expect(out).to include("Generating")
    end
  end
end

