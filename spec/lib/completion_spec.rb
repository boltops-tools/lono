describe Lono::CLI do
  describe "lono completion" do
    commands = {
      "new" => "project_root",
      "generate" => "--clean",
      "cfn" =>  "create",
      "cfn create" =>  "name",
      "param" => "generate",
    }
    commands.each do |command, expected_word|
      it "#{command}" do
        out = execute("exe/lono completion #{command}")
        expect(out).to include(expected_word) # only checking for one word for simplicity
      end
    end
  end
end
