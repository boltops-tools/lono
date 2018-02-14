describe Lono::New do
  after(:each) do
    FileUtils.rm_rf(ENV['LONO_ROOT']) unless ENV['KEEP_TMP_PROJECT']
  end
  before(:each) do
    new_project = Lono::New.new(
      force: true,
      quiet: true,
      format: 'yaml',
      project_root: ENV['TMP_LONO_ROOT'],
    )
    new_project.run
  end

  it "new generates a new project" do
    dsl = Lono::Template::DSL.new(
      quiet: true
    )
    dsl.run
    generated = File.exist?("#{Lono.root}/output/templates/blog-web.yml")
    expect(generated).to be true
  end
end
