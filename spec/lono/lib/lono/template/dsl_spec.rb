describe Lono::Template::Dsl do
  let(:dsl) { Lono::Template::Dsl.new("example") }
  context "run" do
    it "produces template" do
      dsl.run
      exist = File.exist?("tmp/lono_project/output/example/templates/example.yml")
      expect(exist).to be true
    end
  end
end
