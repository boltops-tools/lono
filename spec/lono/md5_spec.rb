describe Lono::Md5 do
  let(:md5) { Lono::Md5 }
  context "file" do
    it "md5" do
      sum = md5.sum("spec/fixtures/output2/blueprint-name/files/a.rb")
      expect(sum).to match "a03f0901"
    end

    it "name" do
      name = md5.name("spec/fixtures/output2/blueprint-name/files/a.rb")
      expect(name).to eq "spec/fixtures/output2/blueprint-name/files/a-a03f0901.rb"
    end
  end

  context "folder" do
    it "md5" do
      sum = md5.sum("spec/fixtures/output2/blueprint-name/files/folder")
      expect(sum).to eq "a03f0901"
    end

    it "name" do
      name = md5.name("spec/fixtures/output2/blueprint-name/files/folder")
      expect(name).to eq "spec/fixtures/output2/blueprint-name/files/folder-a03f0901.zip"
    end
  end

  context "nested folder" do
    it "md5" do
      sum = md5.sum("spec/fixtures/output2/blueprint-name/files/folder1/folder2")
      expect(sum).to eq "a03f0901"
    end

    it "name" do
      name = md5.name("spec/fixtures/output2/blueprint-name/files/folder1/folder2")
      expect(name).to eq "spec/fixtures/output2/blueprint-name/files/folder1/folder2-a03f0901.zip"
    end
  end
end
