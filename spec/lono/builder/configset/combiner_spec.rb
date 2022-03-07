describe Lono::Builder::Configset::Combiner do
  let(:combiner) do
    combiner = Lono::Builder::Configset::Combiner.new(cfn: cfn, metas: []) # metas is empty since we'll call combiner.add directly
    allow(combiner).to receive(:metas_empty?).and_return false
    combiner
  end

  def configset_metadata(name)
    data = IO.read("spec/fixtures/configsets/snippets/#{name}")
    init = if File.extname(name) == ".yml"
      YAML.load(data)
    else
      JSON.load(data)
    end
    {"Metadata" => init} # wrap metadata to create right structure
  end

  def template_data(name)
    YAML.load(IO.read("spec/fixtures/configsets/templates/#{name}"))
  end

  # IE: meta = {name: "name", resource: "resource"}
  # Add to combiner directly so we can test the combine logic
  def build_configset(options={})
    meta = options.slice(:name, :resource)
    metadata = options[:metadata]
    configset = Lono::Configset.new(meta)
    allow(configset).to receive(:metadata).and_return(metadata)
    configset
  end

  context("no existing metadata") do
    let(:cfn)  { template_data("ec2-no-metadata.yml") }
    let(:configset1) { configset_metadata("config1.json") }
    let(:configset2) { configset_metadata("config2.json") }

    it "combines" do
      x = build_configset(name: "ssm", resource: "Instance", metadata: configset1)
      combiner.add(x)
      combiner.add(build_configset(name: "httpd", resource: "Instance", metadata: configset2))
      map = combiner.combine
      json =<<~EOL
      {
        "AWS::CloudFormation::Init": {
          "configSets": {
            "default": [{"ConfigSet": "ssm"},{"ConfigSet": "httpd"}],
            "ssm": ["000_aaa1","000_aaa2"],
            "httpd": ["001_bbb1","001_bbb2"]
          },
          "000_aaa1": {
            "commands": {
              "test": {
                "command": "echo from-aaa1 > test1.txt"
              }
            }
          },
          "000_aaa2": {
            "commands": {
              "test": {
                "command": "echo from-aaa2 > test1.txt"
              }
            }
          },
          "001_bbb1": {
            "commands": {
              "test": {
                "command": "echo from-bbb1 > test2.txt"
              }
            }
          },
          "001_bbb2": {
            "commands": {
              "test": {
                "command": "echo from-bbb2 > test2.txt"
              }
            }
          }
        }
      }
      EOL
      data = map["Instance"]["Metadata"]
      expect(data).to eq(JSON.load(json))
    end
  end

  context("existing metadata multiple configsets") do
    let(:cfn)  { template_data("ec2-multiple.yml") }
    let(:configset1) { configset_metadata("config1.json") }
    let(:configset2) { configset_metadata("config2.json") }

    it "combines" do
      combiner.add_existing
      combiner.add(build_configset(name: "ssm", resource: "Instance", metadata: configset1))
      map = combiner.build_map # callig directly so we can test add_existing
      data = map["Instance"]["Metadata"]
      yaml =<<~EOL
        ---
        AWS::CloudFormation::Init:
          configSets:
            default:
            - ConfigSet: InstanceOriginalConfigset
            - ConfigSet: ssm
            InstanceOriginalConfigset:
            - 000_existing
            ssm:
            - 001_aaa1
            - 001_aaa2
          000_existing:
            commands:
              test:
                command: echo existing >> /tmp/test.txt
          001_aaa1:
            commands:
              test:
                command: echo from-aaa1 > test1.txt
          001_aaa2:
            commands:
              test:
                command: echo from-aaa2 > test1.txt
      EOL
      expect(data).to eq(YAML.load(yaml))
    end
  end

  context("no existing metadata") do
    let(:cfn)  { template_data("ec2-no-metadata.yml") }
    let(:configset1) { configset_metadata("single.yml") }

    it "combine with single config structure" do
      combiner.add(build_configset(name: "simple", resource: "Instance", metadata: configset1))
      map = combiner.combine
      data = map["Instance"]["Metadata"]
      yaml =<<~EOL
      ---
      AWS::CloudFormation::Init:
        configSets:
          default:
          - ConfigSet: simple
          simple:
          - 000_single_generated
        000_single_generated:
          commands:
            c1:
              command: echo c1 >> test.txt
            c2:
              command: echo c2 >> test.txt
      EOL
      expect(data).to eq(YAML.load(yaml))
    end
  end

  context("existing metadata single configsets") do
    let(:cfn)  { template_data("ec2-single.yml") }
    let(:configset1) { configset_metadata("single.yml") }

    it "combines" do
      combiner.add_existing
      combiner.add(build_configset(name: "ssm", resource: "Instance", metadata: configset1))
      map = combiner.build_map
      data = map["Instance"]["Metadata"]
      yaml =<<~EOL
        ---
        AWS::CloudFormation::Init:
          configSets:
            default:
            - ConfigSet: InstanceOriginalConfigset
            - ConfigSet: ssm
            InstanceOriginalConfigset:
            - 000_single_generated
            ssm:
            - 001_single_generated
          000_single_generated:
            commands:
              existing:
                command: existing >> test.txt
          001_single_generated:
            commands:
              c1:
                command: echo c1 >> test.txt
              c2:
                command: echo c2 >> test.txt
      EOL
      expect(data).to eq(YAML.load(yaml))
    end
  end

  #########
  context("duplicate configset added") do
    let(:cfn)  { template_data("ec2-no-metadata.yml") }
    let(:configset1) { configset_metadata("config1.json") }
    let(:configset2) { configset_metadata("config1.json") }

    it "combines should not add duplicate configsets" do
      combiner.add(build_configset(name: "ssm", resource: "Instance", metadata: configset1))
      combiner.add(build_configset(name: "ssm", resource: "Instance", metadata: configset2))
      data = combiner.combine
      yaml =<<~EOL
        ---
        Instance:
          Metadata:
            AWS::CloudFormation::Init:
              000_aaa1:
                commands:
                  test:
                    command: echo from-aaa1 > test1.txt
              000_aaa2:
                commands:
                  test:
                    command: echo from-aaa2 > test1.txt
              configSets:
                default:
                - ConfigSet: ssm
                ssm:
                - 000_aaa1
                - 000_aaa2
      EOL
      expect(data).to eq(YAML.load(yaml))
    end
  end

  context("2 different resources") do
    let(:cfn)  { template_data("ec2-and-sg.yml") }
    let(:configset1) { configset_metadata("config1.json") }
    let(:configset2) { configset_metadata("config2.json") }

    it "combines" do
      combiner.add(build_configset(name: "ssm", resource: "Instance", metadata: configset1))
      combiner.add(build_configset(name: "httpd", resource: "SecurityGroup", metadata: configset2))
      map = combiner.combine
      yaml =<<~EOL
      ---
      Instance:
        Metadata:
          AWS::CloudFormation::Init:
            configSets:
              default:
              - ConfigSet: ssm
              ssm:
              - 000_aaa1
              - 000_aaa2
            000_aaa1:
              commands:
                test:
                  command: echo from-aaa1 > test1.txt
            000_aaa2:
              commands:
                test:
                  command: echo from-aaa2 > test1.txt
      SecurityGroup:
        Metadata:
          AWS::CloudFormation::Init:
            configSets:
              default:
              - ConfigSet: httpd
              httpd:
              - 001_bbb1
              - 001_bbb2
            001_bbb1:
              commands:
                test:
                  command: echo from-bbb1 > test2.txt
            001_bbb2:
              commands:
                test:
                  command: echo from-bbb2 > test2.txt
      EOL
      expect(map).to eq(YAML.load(yaml))
    end
  end

  context("existing metadata 2 different resources") do
    let(:cfn)  { template_data("ec2-and-sg-metadata.yml") }
    let(:configset1) { configset_metadata("config1.json") }
    let(:configset2) { configset_metadata("config2.json") }

    it "combines" do
      combiner.add_existing
      combiner.add(build_configset(name: "ssm", resource: "Instance", metadata: configset1))
      combiner.add(build_configset(name: "httpd", resource: "SecurityGroup", metadata: configset2))
      map = combiner.build_map
      yaml =<<~EOL
        ---
        Instance:
          Metadata:
            AWS::CloudFormation::Init:
              configSets:
                default:
                - ConfigSet: InstanceOriginalConfigset
                - ConfigSet: ssm
                InstanceOriginalConfigset:
                - 000_existing
                ssm:
                - 002_aaa1
                - 002_aaa2
              000_existing:
                commands:
                  test:
                    command: echo existing1 >> /tmp/test.txt
              002_aaa1:
                commands:
                  test:
                    command: echo from-aaa1 > test1.txt
              002_aaa2:
                commands:
                  test:
                    command: echo from-aaa2 > test1.txt
        SecurityGroup:
          Metadata:
            AWS::CloudFormation::Init:
              configSets:
                default:
                - ConfigSet: SecurityGroupOriginalConfigset
                - ConfigSet: httpd
                SecurityGroupOriginalConfigset:
                - 001_existing
                httpd:
                - 003_bbb1
                - 003_bbb2
              001_existing:
                commands:
                  test:
                    command: echo existing2 >> /tmp/test.txt
              003_bbb1:
                commands:
                  test:
                    command: echo from-bbb1 > test2.txt
              003_bbb2:
                commands:
                  test:
                    command: echo from-bbb2 > test2.txt
        EOL

      expect(map).to eq(YAML.load(yaml))
    end
  end
end
