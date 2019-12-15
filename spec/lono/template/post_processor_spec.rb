describe Lono::Template::PostProcessor do
  let(:processor) do
    processor = Lono::Template::PostProcessor.new(blueprint: "example")
    allow(processor).to receive(:registry_items).and_return(registry_items)
    allow(processor).to receive(:template).and_return(template)
    allow(processor).to receive(:write_template!)
    processor
  end
  let(:template) do
    YAML.load_file("spec/fixtures/raw_templates/example.yml")
  end
  let(:registry_items) do
    [
      Lono::AppFile::Registry::Item.new("folder", "example"),
      Lono::AppFile::Registry::Item.new("folder1/folder2/c.rb", "example"),
    ]
  end

  context "test" do
    it "run" do
      processor.run
      yaml = YAML.dump(processor.template)
      expect(yaml).to eq(<<~EOL)
        ---
        Resources:
          FolderFunction:
            Type: AWS::Lambda::Function
            Properties:
              Code:
                S3Bucket: my-bucket
                S3Key: development/example/files/folder-a328be46.zip
          FileFunction:
            Type: AWS::Lambda::Function
            Properties:
              Code:
                S3Bucket: my-bucket
                S3Key: development/example/files/folder1/folder2/c.rb-d41d8cd9.zip
      EOL
    end
  end
end
