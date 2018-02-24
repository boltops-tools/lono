describe Lono::Help::Markdown do
  let(:markdown) { Lono::Help::Markdown.new(cli_class, command) }
  let(:cli_class) { Lono::CLI }

  context "generate" do
    let(:command) { "import" }

    it "#usage" do
      expect(markdown.usage).to eq "lono generate"
    end

    it "#summary" do
      expect(markdown.summary).to eq "Generate both CloudFormation templates and parameters files"
    end

    it "#options" do
      expect(markdown.options).to include("--clean")
      # [--clean], [--no-clean]  # remove all output files before generating
      #                          # Default: true
      # [--quiet], [--no-quiet]  # silence the output
    end

    it "#description" do
      expect(markdown.description).to include("    lono generate")
    end

    it "#doc" do
      puts markdown.doc
    end

    it "#make_all" do
      Lono::Help::MarkdownMaker.make_all(cli_class)
    end
  end

  ################
  # rest are edge cases
  context "summary" do
    let(:command) { "summary" }

    # empty options
    it "#options" do
      expect(markdown.options).to eq ""
    end

    # empty description
    it "#description" do
      expect(markdown.description).to eq ""
    end

    it "#doc" do
      puts markdown.doc
    end
  end
end
