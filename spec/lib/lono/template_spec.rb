describe Lono do
  before(:each) do
    @env = "LONO_ROOT=tmp/foo"
    lono_bin = File.expand_path("../../../../exe/lono", __FILE__)
    execute("cd tmp && #{lono_bin} new foo --force --quiet --format json")
  end

  after(:each) do
    # FileUtils.rm_rf("foo") unless ENV['KEEP_TMP_PROJECT']
  end

  describe "bashify" do
    it "should convert cfn user_data to bash script" do
      path = "spec/fixtures/cfn.json"
      out = execute("./exe/lono template bashify #{path}")
      expect(out).to match /bash -lexv/
    end
  end

  describe "cli specs" do
    it "should generate templates" do
      out = execute("#{@env} ./exe/lono template generate --clean")
      expect(out).to match /Generating CloudFormation templates/
    end

    it "should upload templates" do
      out = execute("#{@env} ./exe/lono template upload --noop")
      expect(out).to match /Templates uploaded to s3/
    end
  end
end
