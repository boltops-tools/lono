describe Lono::Md5 do
  let(:md5) { Lono::Md5 }
  context "file" do
    it "md5" do
      sum = md5.sum("spec/fixtures/md5/a.rb")
      expect(sum).to match "a03f0901"
    end

    it "name" do
      name = md5.name("spec/fixtures/md5/a.rb")
      expect(name).to eq "spec/fixtures/md5/a-a03f0901.rb"
    end
  end

  context "folder" do
    it "md5" do
      sum = md5.sum("spec/fixtures/md5/folder")
      expect(sum).to eq "a03f0901"
    end

    it "name" do
      name = md5.name("spec/fixtures/md5/folder")
      expect(name).to eq "spec/fixtures/md5/folder-a03f0901.zip"
    end
  end

  context "nested folder" do
    it "md5" do
      sum = md5.sum("spec/fixtures/md5/folder1/folder2")
      expect(sum).to eq "a03f0901"
    end

    it "name" do
      name = md5.name("spec/fixtures/md5/folder1/folder2")
      expect(name).to eq "spec/fixtures/md5/folder1/folder2-a03f0901.zip"
    end
  end
end
