describe Lono::Template::Strategy::Erb do
  context "tmp/lono_project" do
    it "#evaluate_templates" do
      erb = Lono::Template::Strategy::Erb.new(blueprint: "erb-demo", quiet: true)
      erb.evaluate_templates
      templates = erb.instance_variable_get(:@templates)
      template_names = templates.map { |h| h[:name] }
      expect(template_names).to include("erb-demo")
    end
  end

  context "lono generate" do
    before(:each) do
      erb = Lono::Template::Strategy::Erb.new(blueprint: "erb-demo", quiet: true)
      erb.run
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
end
