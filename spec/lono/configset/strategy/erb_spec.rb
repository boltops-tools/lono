describe Lono::Configset::Strategy::Erb do
  let(:erb) do
    Lono::Configset::Strategy::Erb.new(options)
  end
  let(:options) do
    {
      root: "spec/fixtures/configsets/erb/httpd",
      configset: "httpd",
      resource: "TestResource",
    }
  end

  context("example") do
    it "build" do
      metadata = erb.build
      expect(metadata).to be_a(Hash)
      data = metadata["Metadata"]
      init_key = data.key?("AWS::CloudFormation::Init")
      expect(init_key).to be true
      template =<<~EOL
---
AWS::CloudFormation::Init:
  configSets:
    default:
    - httpd
  httpd:
    packages:
      yum:
        httpd: []
    files:
      "/var/www/html/index.html":
        content: |
          <h1>Test page</h1>
          <p>Test content.</p>
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
