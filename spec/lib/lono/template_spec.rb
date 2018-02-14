describe Lono do
  before(:each) do
    @env = "LONO_ROOT=tmp/foo"
    lono_bin = File.expand_path("../../../../bin/lono", __FILE__)
    execute("cd tmp && #{lono_bin} new foo -f -q --format json")
  end

  after(:each) do
    # FileUtils.rm_rf("foo") unless ENV['KEEP_TMP_PROJECT']
  end

  describe "bashify" do
    it "should convert cfn user_data to bash script" do
      path = "#{$root}/spec/fixtures/cfn.json"
      out = execute("./bin/lono template bashify #{path}")
      expect(out).to match /bash -lexv/
    end
  end

  describe "cli specs" do
    it "should generate templates" do
      out = execute("#{@env} ./bin/lono template generate -c")
      expect(out).to match /Generating CloudFormation templates/
    end

    it "should upload templates" do
      out = execute("#{@env} ./bin/lono template upload --noop")
      expect(out).to match /Templates uploaded to s3/
    end
  end
end
