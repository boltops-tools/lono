describe Lono::Md5 do
  let(:md5) { Lono::Md5 }
  context "file" do
    it "md5" do
      sum = md5.sum("spec/fixtures/output/blueprint-name/files/a.rb")
      expect(sum).to match "d41d8cd9"
    end

    it "name" do
      name = md5.name("spec/fixtures/output/blueprint-name/files/a.rb")
      expect(name).to eq "a-d41d8cd9.rb"
    end
  end

  context "folder" do
    it "md5" do
      sum = md5.sum("spec/fixtures/output/blueprint-name/files/folder")
      expect(sum).to eq "d41d8cd9"
    end

    it "name" do
      name = md5.name("spec/fixtures/output/blueprint-name/files/folder")
      expect(name).to eq "folder-d41d8cd9."
    end
  end

  context "nested folder" do
    it "md5" do
      sum = md5.sum("spec/fixtures/output/blueprint-name/files/folder1/folder2")
      expect(sum).to eq "d41d8cd9"
    end

    it "name" do
      name = md5.name("spec/fixtures/output/blueprint-name/files/folder1/folder2")
      expect(name).to eq "folder1/folder2-d41d8cd9."
    end
  end
end
