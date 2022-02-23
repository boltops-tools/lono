describe Lono::Builder::Configset::Definition::Erb do
  let(:erb) do
    path = "spec/fixtures/configsets/erb/httpd/configset.yml"
    Lono::Builder::Configset::Definition::Erb.new(path)
  end

  context("example") do
    it "evaluate" do
      metadata = erb.evaluate
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
        content: 'test html

'
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
