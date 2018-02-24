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

    it "#desc_markdown" do
      expect(page.desc_markdown).to include "# Description"
    end

    it "#options_markdown" do
      expect(page.options_markdown).to include("--clean")
      # [--clean], [--no-clean]  # remove all output files before generating
      #                          # Default: true
      # [--quiet], [--no-quiet]  # silence the output
    end

    it "#doc" do
      expect(page.doc).to include("# Description")
      # puts page.doc # uncomment to see generated page for debugging
    end
  end

  # subcommand
  context "cfn" do
    let(:command) { "cfn" }

    it "#usage" do
      expect(page.usage).to eq "lono cfn SUBCOMMAND"
    end

    it "#desc_markdown" do
      puts page.desc_markdown
      expect(page.desc_markdown).to include "# Description"
    end

    # Think it is better to hide subcommand options_markdown at the top-level.
    # User will see the optoins once they click into the subcommand.
    it "#options_markdown" do
      expect(page.options_markdown).to include("")
    end

    it "#subcommand_list" do
      expect(page.doc).to include("# Subcommands")
      # puts page.subcommand_list # uncomment to see generated list for debugging
    end

    it "#doc" do
      expect(page.doc).to include("# Description")
      # puts page.doc # uncomment to see generated page for debugging
    end
  end

  ################
  # rest are edge cases
  context "summary" do
    let(:command) { "summary" }

    # empty options_markdown
    it "#options_markdown" do
      expect(page.options_markdown).to eq ""
    end

    it "#doc" do
      expect(page.doc).to include("# Description")
      # puts page.doc # uncomment to see generated page for debugging
    end
  end
end
