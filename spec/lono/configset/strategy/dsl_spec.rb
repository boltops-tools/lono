describe Lono::Configset::Strategy::Dsl do
  let(:dsl) do
    Lono::Configset::Strategy::Dsl.new(options)
  end
  let(:options) do
    {
      root: "spec/fixtures/configsets/dsl/httpd",
      configset: "httpd",
      resource: "TestResource",
    }
  end

  context("example") do
    it "build" do
      data = dsl.build
      expect(data).to be_a(Hash)
      init_key = data.key?("AWS::CloudFormation::Init")
      expect(init_key).to be true
      template =<<~EOL
---
AWS::CloudFormation::Init:
  configSets:
    default:
    - main
  main:
    packages:
      yum:
        httpd: []
    files:
      "/var/www/html/index.html":
        content: "<h1>headline</h1>"
    services:
      sysvinit:
        httpd:
          enabled: true
          ensureRunning: true
EOL
      expect(YAML.dump(data)).to eq template
    end
  end
end
