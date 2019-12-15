describe Lono::CLI do
  describe "lono completion" do
    commands = {
      # "new" => "name", # options is the completion because it's a Thor::Group
      "generate blueprint" => "--clean",
      "cfn" =>  "deploy",
      "cfn deploy" =>  "stack",
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
