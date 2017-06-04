require_relative "../spec_helper"

describe Lono do
  describe "lono" do
    it "generate should build templates" do
      out = execute("./bin/lono generate --project-root spec/fixtures/my_project")
      expect(out).to match /Generating both CloudFormation template and parameter/
    end
  end
end

