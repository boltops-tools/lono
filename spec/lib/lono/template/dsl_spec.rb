describe Lono::Template::DSL do
  context "tmp/lono_project" do
    it "#evaluate_templates" do
      dsl = Lono::Template::DSL.new(
        quiet: true
      )
      dsl.evaluate_templates
      templates = dsl.instance_variable_get(:@templates)
      template_names = templates.map { |h| h[:name] }
      expect(template_names).to include("example")
    end
  end

  context "lono generate" do
    before(:each) do
      dsl = Lono::Template::DSL.new(quiet: true)
      dsl.run
    end

    it "should generate cloudformation template" do
      template = YAML.load_file("#{Lono.root}/output/templates/example.yml")
      expect(template['Description']).to include "AWS CloudFormation Sample Template"
    end

    # <%= partial("security_group", desc: "whatever", port: 22)
    it "partial local variables become instance variables in partial view" do
      template = YAML.load_file("#{Lono.root}/output/templates/example.yml")
      desc = template['Resources']['InstanceSecurityGroup']['Properties']['GroupDescription']
      expect(desc).to eq 'Enable SSH access via port 22'
    end

    it "partials should have access to variables" do
      text = IO.read("#{Lono.root}/output/templates/example.yml")
      expect(text).to include("override_test=overridden-by-development")
    end

    it "should have access to custom helpers" do
      text = IO.read("#{Lono.root}/output/templates/example.yml")
      expect(text).to include("custom_helper value")
    end
  end
end
