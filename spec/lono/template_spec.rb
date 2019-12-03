describe Lono do
  describe "bashify" do
    it "should convert cfn user_data to bash script" do
      path = "spec/fixtures/cfn.json"
      out = execute("exe/lono template bashify #{path}")
      expect(out).to match /bash -lexv/
    end
  end

  describe "cli specs" do
    it "should generate templates" do
      out = execute("exe/lono template generate example --clean")
      expect(out).to match /Generating CloudFormation templates/
    end

    it "should upload templates" do
      out = execute("exe/lono template upload example --noop")
      expect(out).to match /Templates uploaded to s3/
    end
  end
end
