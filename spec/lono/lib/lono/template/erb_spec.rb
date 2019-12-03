describe Lono::Template::Erb do
  context "tmp/lono_project" do
    it "#evaluate_templates" do
      dsl = Lono::Template::Erb.new("erb-demo", quiet: true)
      dsl.evaluate_templates
      templates = dsl.instance_variable_get(:@templates)
      template_names = templates.map { |h| h[:name] }
      expect(template_names).to include("erb-demo")
    end
  end

  context "lono generate" do
    before(:each) do
      dsl = Lono::Template::Erb.new("erb-demo", quiet: true)
      dsl.run
    end

    it "should generate cloudformation template" do
      template = YAML.load_file("#{Lono.root}/output/erb-demo/templates/erb-demo.yml")
      expect(template.key?('Resources')).to be true
    end

    # <%= partial("security_group", desc: "whatever", port: 22)
    it "partial local variables become instance variables in partial view" do
      template = YAML.load_file("#{Lono.root}/output/erb-demo/templates/erb-demo.yml")
      desc = template['Resources']['SecurityGroup']['Properties']['GroupDescription']
      expect(desc).to eq 'demo security group'
    end

    it "partials should have access to variables" do
      text = IO.read("#{Lono.root}/output/erb-demo/templates/erb-demo.yml")
      expect(text).to include("overridden-by-development")
    end

    it "should have access to custom helpers" do
      text = IO.read("#{Lono.root}/output/erb-demo/templates/erb-demo.yml")
      expect(text).to include("custom_helper value")
    end
  end

  context "yaml parse error" do
    let(:dsl) do
      Lono::Template::Erb.new("erb-demo", quiet: true)
    end

    it "show exact line of error code when yaml is invalid" do
      IO.write("tmp/bad.yml", <<EOL)
test: 1
foo
  test
EOL
      out = dsl.validate_yaml("tmp/bad.yml")
      expect(out).to include("2 foo")
    end

  end
end
