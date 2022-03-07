describe Lono::Builder::Configset::Definition::Dsl do
  let(:dsl) do
    path = "spec/fixtures/configsets/dsl/httpd/configset.rb"
    meta = {path: path, resource: "LaunchTemplate", name: "main"}
    dsl = Lono::Builder::Configset::Definition::Dsl.new(meta: meta)
    configset = Lono::Configset.new(meta)
    allow(configset).to receive(:path).and_return path
    dsl.instance_variable_set(:@configset, configset)
    dsl
  end

  context("example") do
    it "evaluate" do
      metadata = dsl.evaluate
      expect(metadata).to be_a(Hash)
      data = metadata["Metadata"]
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
