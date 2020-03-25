describe Lono::Template::ConfigsetInjector do
  let(:injector) do
    injector = Lono::Template::ConfigsetInjector.new(blueprint: "ec2")
    allow(injector).to receive(:load_template).and_return(cfn)
    allow(injector).to receive(:write)
    injector
  end

  # Not testing template with existing metadata because the combiner already should return it.
  # Tested at the Combiner level.
  context "template has no existing metdata" do
    let(:cfn) do
      YAML.load_file("spec/fixtures/configsets/snippets/templates/ec2-no-metadata.yml")
    end
    let(:metadata_map) do
      json =<<~EOL
        {
          "Metadata": {
            "AWS::CloudFormation::Init": {
              "configSets": {
                "default": ["s1"]
              },
              "s1": {
                "commands": {
                  "test": {
                    "command": "echo from-aaa1 > test1.txt"
                  }
                }
              }
            }
          }
        }
      EOL
      {"Instance" => JSON.load(json)} # will add to instance
    end

    it "adds cfn-init metadata" do
      allow(injector).to receive(:metadata_map).and_return(metadata_map)

      # Lono::Configset::Register::Blueprint.configsets
      cfn = injector.run
      yaml =<<~EOL
        ---
        Resources:
          Instance:
            Type: AWS::EC2::Instance
            Properties:
              ImageId: ami-111
              InstanceType: t3.micro
            Metadata:
              AWS::CloudFormation::Init:
                configSets:
                  default:
                  - s1
                s1:
                  commands:
                    test:
                      command: echo from-aaa1 > test1.txt
      EOL
      expect(cfn).to eq(YAML.load(yaml))
    end
  end
end
