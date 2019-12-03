describe Lono::CLI do
  context "general" do
    it "new generate new project" do
      # using another name for the lono project because we call
      # exe/lono new lono_project for all specs via the RSpec.config already
      # NOTE: LONO_ROOT modified in the spec_helper.rb
      FileUtils.rm_rf("tmp/test_project")
      execute("cd tmp && ../exe/lono new test_project --no-bundle")
      exist = File.exist?("tmp/test_project/configs/settings.yml")
      expect(exist).to be true
    end
  end

  # Ensure the example starter project is always able to produce output/templates.
  context "project generated from lono new command" do
    before(:all) do
      # hack to so we don't have to change LONO_ROOT
      @project = ENV['LONO_ROOT']
      FileUtils.mv(@project, "#{@project}.temp") if File.exist?(@project)
    end
    after(:all) do
      FileUtils.rm_rf(@project)
      # move temp back for the rest of the tests
      FileUtils.mv("#{@project}.temp", @project) if File.exist?("#{@project}.temp")
    end

    it "generate should build templates" do
      # NOTE: LONO_ROOT modified in the spec_helper.rb
      execute("cd tmp && ../exe/lono new lono_project --no-bundle")
      execute("exe/lono generate")
      success = $?.exitstatus == 0
      expect(success).to be true

      exist = File.exist?("#{Lono.root}/configs/settings.yml")
      expect(exist).to be true
    end
  end
end
