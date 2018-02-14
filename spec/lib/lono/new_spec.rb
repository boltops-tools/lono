describe Lono::New do
  before(:each) do
    @saved_root = ENV['LONO_ROOT']
    ENV['LONO_ROOT'] = ENV['TMP_LONO_ROOT']
  end
  after(:each) do
    ENV['LONO_ROOT'] = @saved_root
    FileUtils.rm_rf(ENV['TMP_LONO_ROOT']) unless ENV['KEEP_TMP_PROJECT']
  end

  context "json starter project" do
    before(:each) do
      new_project = Lono::New.new(
        force: true,
        quiet: true,
        format: 'json',
        project_root: ENV['TMP_LONO_ROOT'],
      )
      new_project.run
    end

    it "should be able to lono generate" do
      dsl = Lono::Template::DSL.new(
        quiet: true
      )
      dsl.run
      generated = File.exist?("#{Lono.root}/output/blog-web.json")
      expect(generated).to be true
    end
  end

  context "yml starter project" do
    before(:each) do
      new_project = Lono::New.new(
        force: true,
        quiet: true,
        format: 'yaml',
        project_root: ENV['TMP_LONO_ROOT'],
      )
      new_project.run
    end

    it "should be able to lono generate" do
      dsl = Lono::Template::DSL.new(
        quiet: true
      )
      dsl.run
      generated = File.exist?("#{Lono.root}/output/blog-web.yml")
      expect(generated).to be true
    end
  end

  context "multiple format starter project" do
    # TODO: this should not generate anything but puts out a message to the user that the
    # project needs to be either all yaml or all json format
  end
end
