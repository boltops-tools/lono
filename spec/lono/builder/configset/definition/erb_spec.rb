describe Lono::Builder::Configset::Definition::Erb do
  let(:erb) do
    path = "spec/fixtures/configsets/erb/httpd/configset.yml"
    meta = {path: path, resource: "LaunchTemplate", name: "main"}
    erb = Lono::Builder::Configset::Definition::Erb.new(blueprint: "demo", meta: meta)
    configset = Lono::Configset.new(meta)
    allow(configset).to receive(:path).and_return path
    allow(configset).to receive(:root).and_return "spec/fixtures/configsets/erb/httpd"
    erb.instance_variable_set(:@configset, configset)
    erb
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
