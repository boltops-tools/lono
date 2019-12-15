describe Lono::Template::Strategy::Dsl do
  let(:dsl) { Lono::Template::Strategy::Dsl.new(blueprint: "example") }
  context "run" do
    it "produces template" do
      dsl.run
      exist = File.exist?("tmp/lono_project/output/example/templates/example.yml")
      expect(exist).to be true
    end
  end
end
