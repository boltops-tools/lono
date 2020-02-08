describe Lono::Configset::Combiner do
  let(:combiner) do
    Lono::Configset::Combiner.new(cfn)
  end

  def load_configset(name)
    data = IO.read("spec/fixtures/configsets/snippets/#{name}")
    if File.extname(name) == ".yml"
      YAML.load(data)
    else
      JSON.load(data)
    end
  end

  def load_template(name)
    YAML.load(IO.read("spec/fixtures/configsets/snippets/templates/#{name}"))
  end

  def registry(*args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    Lono::Configset::Registry.new(args, options)
  end

  context("no existing metadata") do
    let(:cfn)  { load_template("ec2-no-metadata.yml") }
    let(:configset1) { load_configset("config1.json") }
    let(:configset2) { load_configset("config2.json") }

    it "combines" do
      combiner.add(registry("ssm", resource: "Instance"), configset1)
      combiner.add(registry("httpd", resource: "Instance"), configset2)
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
      data = map["Instance"]
      expect(data).to eq(JSON.load(json))
    end
  end

  context("existing metadata multiple configsets") do
    let(:cfn)  { load_template("ec2-multiple.yml") }
    let(:configset1) { load_configset("config1.json") }
    let(:configset2) { load_configset("config2.json") }

    it "combines" do
      combiner.existing_configsets.each do |data|
        combiner.add(data[:registry], data[:metdata_configset])
      end
      combiner.add(registry("ssm", resource: "Instance"), configset1)
      map = combiner.combine
      data = map["Instance"]
      json =<<~EOL
        {
          "AWS::CloudFormation::Init": {
            "configSets": {
              "default": [
                {
                  "ConfigSet": "InstanceOriginalConfigset"
                },
                {
                  "ConfigSet": "ssm"
                }
              ],
              "InstanceOriginalConfigset": [
                "000_existing"
              ],
              "ssm": [
                "001_aaa1",
                "001_aaa2"
              ]
            },
            "000_existing": {
              "commands": {
                "test": {
                  "command": "echo existing >> /tmp/test.txt"
                }
              }
            },
            "001_aaa1": {
              "commands": {
                "test": {
                  "command": "echo from-aaa1 > test1.txt"
                }
              }
            },
            "001_aaa2": {
              "commands": {
                "test": {
                  "command": "echo from-aaa2 > test1.txt"
                }
              }
            }
          }
        }
      EOL
      expect(data).to eq(JSON.load(json))
    end
  end

  context("no existing metadata") do
    let(:cfn)  { load_template("ec2-no-metadata.yml") }
    let(:configset1) { load_configset("single.yml") }

    it "combine with single config structure" do
      combiner.add(registry("simple", resource: "Instance"), configset1)
      map = combiner.combine
      data = map["Instance"]
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
    let(:cfn)  { load_template("ec2-single.yml") }
    let(:configset1) { load_configset("single.yml") }

    it "combines" do
      combiner.existing_configsets.each do |data|
        combiner.add(data[:registry], data[:metdata_configset])
      end
      combiner.add(registry("ssm", resource: "Instance"), configset1)
      map = combiner.combine
      data = map["Instance"]
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
    let(:cfn)  { load_template("ec2-no-metadata.yml") }
    let(:configset1) { load_configset("config1.json") }
    let(:configset2) { load_configset("config1.json") }

    it "combines" do
      combiner.add(registry("ssm", resource: "Instance"), configset1)
      combiner.add(registry("ssm", resource: "Instance"), configset2)
      map = combiner.combine
      json =<<~EOL
        {
          "AWS::CloudFormation::Init": {
            "configSets": {
              "default": [
                {
                  "ConfigSet": "ssm"
                }
              ],
              "ssm": [
                "000_aaa1",
                "000_aaa2"
              ]
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
            }
          }
        }
      EOL
      data = map["Instance"]
      expect(data).to eq(JSON.load(json))
    end
  end

  context("2 different resources") do
    let(:cfn)  { load_template("ec2-and-sg.yml") }
    let(:configset1) { load_configset("config1.json") }
    let(:configset2) { load_configset("config2.json") }

    it "combines" do
      combiner.add(registry("ssm", resource: "Instance"), configset1)
      combiner.add(registry("httpd", resource: "SecurityGroup"), configset2)
      map = combiner.combine
      yaml =<<~EOL
      ---
      Instance:
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
    let(:cfn)  { load_template("ec2-and-sg-metadata.yml") }
    let(:configset1) { load_configset("config1.json") }
    let(:configset2) { load_configset("config2.json") }

    it "combines" do
      combiner.existing_configsets.each do |data|
        combiner.add(data[:registry], data[:metdata_configset])
      end
      combiner.add(registry("ssm", resource: "Instance"), configset1)
      combiner.add(registry("httpd", resource: "SecurityGroup"), configset2)
      map = combiner.combine
      yaml =<<~EOL
        ---
        Instance:
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
