describe Lono::Markdown::Page do
  let(:page) { Lono::Markdown::Page.new(cli_class, command, parent_command_name) }
  let(:cli_class) { Lono::CLI }
  let(:parent_command_name) { nil }

  context "MarkdownMaker.create_all" do
    it "docs command" do
      out = execute("rake docs")
      expect(out).to include("Creating")
    end

    it "generates all docs pages" do
      Lono::Markdown::Creator.mute = true
      Lono::Markdown::Creator.create_all(cli_class)
    end
  end

  context "generate" do
    let(:command) { "generate" }

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
      expect(page.doc).to include("# Summary")
      # puts page.doc # uncomment to see generated page for debugging
    end
  end

  # subcommand
  context "cfn" do
    let(:command) { "cfn" }

    it "#usage" do
      expect(page.usage).to eq "lono cfn SUBCOMMAND"
    end

    it "#summary" do
      expect(page.summary).to eq "cfn subcommand tasks"
    end

    # Think it is better to hide subcommand options at the top-level.
    # User will see the optoins once they click into the subcommand.
    it "#options" do
      expect(page.options).to include("")
    end

    it "#description" do
      expect(page.description).to include("Examples")
    end

    it "#subcommand_list" do
      expect(page.doc).to include("# Subcommands")
      # puts page.subcommand_list # uncomment to see generated list for debugging
    end

    it "#doc" do
      expect(page.doc).to include("# Summary")
      # puts page.doc # uncomment to see generated page for debugging
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
      expect(page.doc).to include("# Summary")
      # puts page.doc # uncomment to see generated page for debugging
    end
  end
end
