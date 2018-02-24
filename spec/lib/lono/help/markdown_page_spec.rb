describe Lono::Help::MarkdownPage do
  let(:page) { Lono::Help::MarkdownPage.new(cli_class, command) }
  let(:cli_class) { Lono::CLI }

  context "MarkdownMaker.make_all" do
    it "generates all docs pages" do
      Lono::Help::MarkdownMaker.make_all(cli_class)
    end
  end

  context "generate" do
    let(:command) { "import" }

    it "#usage" do
      expect(page.usage).to eq "lono generate"
    end

    it "#summary" do
      expect(page.summary).to eq "Generate both CloudFormation templates and parameters files"
    end

    it "#options" do
      expect(page.options).to include("--clean")
      # [--clean], [--no-clean]  # remove all output files before generating
      #                          # Default: true
      # [--quiet], [--no-quiet]  # silence the output
    end

    it "#description" do
      expect(page.description).to include("    lono generate")
    end

    it "#doc" do
      puts page.doc
    end
  end

  # subcommand
  context "cfn" do
    let(:command) { "cfn" }

    it "#usage" do
      expect(page.usage).to eq "lono generate"
    end

    it "#summary" do
      expect(page.summary).to eq "Generate both CloudFormation templates and parameters files"
    end

    it "#options" do
      expect(page.options).to include("--clean")
      # [--clean], [--no-clean]  # remove all output files before generating
      #                          # Default: true
      # [--quiet], [--no-quiet]  # silence the output
    end

    it "#description" do
      expect(page.description).to include("    lono generate")
    end

    it "#subcommand_list" do
      puts page.subcommand_list
    end

    it "#doc" do
      puts page.doc
    end
  end


  ################
  # rest are edge cases
  context "summary" do
    let(:command) { "summary" }

    # empty options
    it "#options" do
      expect(page.options).to eq ""
    end

    # empty description
    it "#description" do
      expect(page.description).to eq ""
    end

    it "#doc" do
      puts page.doc
    end
  end
end
